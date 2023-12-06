import Foundation

class Day06: AdventDay {
    let races: [Race]

    let bigRace: Race

    init() {
        let lines = Self.dataLines
        let times = lines[0].split(separator: ":")[1].split(separator: " ").map { Int($0)! }
        let distances = lines[1].split(separator: ":")[1].split(separator: " ").map { Int($0)! }
        
        self.races = zip(times, distances).map { Race(time: $0, distance: $1) }
        self.bigRace = Race(
            time: Int(lines[0].split(separator: ":")[1].filter { !$0.isWhitespace })!,
            distance: Int(lines[1].split(separator: ":")[1].filter { !$0.isWhitespace })!
        )
    }

    func part1() -> Any {
        races
            .map(\.winningRangeIntegers.wholeIntegersCount)
            .reduce(1, *)
    }

    func part2() -> Any {
        bigRace.winningRangeIntegers.wholeIntegersCount 
    }
}

struct Race {
    let time: Int
    let distance: Int

    var winningRangeIntegers: ClosedRange<Int> {
        let (t, d) = (Double(time), Double(distance))
        let deltaSqrt = sqrt(t*t - 4*d)
        let x1 = (-t + deltaSqrt) / -2
        let x2 = (-t - deltaSqrt) / -2

        let start = Int(x1.representsInteger ? x1 + 1 : ceil(x1))
        let end = Int(x2.representsInteger ? x2 - 1 : floor(x2))

        return start ... end
    }
}

extension ClosedRange<Int> {
    var wholeIntegersCount: Int {
        return upperBound - lowerBound + 1
    }
}

extension Double {
    var representsInteger: Bool {
        return floor(self) == self
    }
}