class Day04: AdventDay {
    let cards: [Card]

    init() {
        self.cards = Self.dataLines.map { line in 
            let nums = line.split(separator: ":")[1].split(separator: "|")
            return Card(
                winningNumers: Set(nums[0].split(separator: " ").map { Int($0)! }),
                numbers: Set(nums[1].split(separator: " ").map { Int($0)! })
            )
        }
    }

    func part1() -> Any {
        cards
            .map(\.points)
            .reduce(0, +)
    }

    func part2() -> Any {
        var cardsAmounts = cards.map { ($0, 1) }
        for i in cardsAmounts.indices {
            let (card, amount) = cardsAmounts[i]
            if card.winningNumersCount == 0 { continue }
            for j in 1 ... (card.winningNumersCount) {
                if i + j > cardsAmounts.count - 1 { continue }
                cardsAmounts[i + j].1 += amount
            }
        }
        return cardsAmounts
            .map { $1 }
            .reduce(0, +)
    }
}

struct Card: Hashable {
    let winningNumers: Set<Int>
    let numbers: Set<Int>

    var points: Int {
        1 << (winningNumersCount - 1)
    }

    var winningNumersCount: Int {
        numbers.intersection(winningNumers).count
    }
}