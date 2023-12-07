class Day07: AdventDay {
    fileprivate let games: [(cards: String, bid: Int)]

    init() {
        self.games = Self.dataLines.map { line in
            let x = line.split(separator: " ")
            return (cards: String(x[0]), bid: Int(x[1])!)
        }
    }

    func part1() -> Any {
        let sortedGames = games
            .sorted { game1, game2 in 
                return Hand(cards: game1.cards) < Hand(cards: game2.cards)
            }

        return sortedGames
            .enumerated()
            .map { ($0 + 1) * $1.bid }
            .reduce(0, +)
    }

    func part2() -> Any {
        let sortedGames = games
            .sorted { game1, game2 in 
                return JokerHand(cards: game1.cards) < JokerHand(cards: game2.cards)
            }
        return sortedGames
            .enumerated()
            .map { ($0 + 1) * $1.bid }
            .reduce(0, +)
    }
}


fileprivate struct Hand: Comparable {
    let cards: String

    static func isGreater(_ s1: String, from s2: String) -> Bool {
        for (c1, c2) in zip(s1, s2) {
            if c1 == c2 {
                continue
            }
            return c1.cardValue < c2.cardValue
        }
        return false
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        let (lt, rt) = (HandType(fromHand: lhs), HandType(fromHand: rhs))
        switch (lt.score - rt.score) {
            case let x where x < 0: return true
            case let x where x > 0: return false
            default: 
            return isGreater(lhs.cards, from: rhs.cards)
        }
    }
}

fileprivate struct JokerHand: Comparable {
    let cards: String

    static func isGreater(_ s1: String, from s2: String) -> Bool {
        for (c1, c2) in zip(s1, s2) {
            if c1 == c2 {
                continue
            }
            return c1.cardValueWithJoker < c2.cardValueWithJoker
        }
        return false
    }

    static func < (lhs: JokerHand, rhs: JokerHand) -> Bool {
        let (lt, rt) = (HandType(fromHand: lhs), HandType(fromHand: rhs))
        switch (lt.score - rt.score) {
            case let x where x < 0: return true
            case let x where x > 0: return false
            default: 
            return isGreater(lhs.cards, from: rhs.cards)
        }
    }
}




fileprivate enum HandType {
    case fiveOKind, fourOKind, house, threeOKind, twoPair, onePair, highCard

    static private func getType(counter: [Character: Int]) -> HandType {
        if (counter.count == 1) {
             return .fiveOKind
        }
        else if (counter.count == 5) { 
            return .highCard  
        }
        else if (counter.contains { $0.value == 4}) {
            return .fourOKind
        }
        else if (counter.contains { $0.value == 3}) {
            return counter.contains { $0.value == 2} ? .house : .threeOKind
        }
        else {
            return counter.filter({ $0.value == 2}).count == 2 ? .twoPair : .onePair
        }
    }


    init(fromHand hand: Hand) {
        self = Self.getType(counter: hand.cards.asCounter)
    }

    init(fromHand hand: JokerHand) {
        let c = hand.cards.asCounter
        if !(hand.cards.contains("J")) {
            self = Self.getType(counter: c)
            return 
        }
        if (c.count == 1) { 
            self = .fiveOKind
            return
        }

        let jokers = c["J"]!
        let mostCommonChar = c
            .filter { $0.key != "J" }
            .max { ($1.value - $0.value) > 0 }
        

        var newC = [Character: Int]()
        for (k, v) in c {
            if k == "J" {
                continue
            }
            newC[k] = k == mostCommonChar!.key ? v + jokers : v
        }
        self = Self.getType(counter: newC)
    }

    var score: Int {
        switch self {
        case .fiveOKind:  return 7
        case .fourOKind:  return 6
        case .house:      return 5
        case .threeOKind: return 4
        case .twoPair:    return 3
        case .onePair:    return 2
        case .highCard:   return 1
        }
    }
}

fileprivate extension String {
    var asCounter: [Character: Int] {
        var counter: [Character: Int] = [:]
        for character in self {
            counter[character] = counter[character] != nil ? counter[character]! + 1 : 1
        }
        return counter
    }
}

fileprivate extension Character {
    var cardValue: Int {
        if let v = self.wholeNumberValue {
            return v
        }
        switch self {
            case "T": return 10
            case "J": return 11
            case "Q": return 12
            case "K": return 13
            case "A": return 14
            default:
                fatalError("its bad")
        }
    }

    var cardValueWithJoker: Int {
        if let v = self.wholeNumberValue {
            return v
        }
        switch self {
            case "J": return 01
            case "T": return 10
            case "Q": return 12
            case "K": return 13
            case "A": return 14
            default:
                fatalError("its bad")
        }
    }
}
