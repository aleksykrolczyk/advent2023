let numbers = [
    "zero": 0,
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9
]

class Day1: AdventDay  {
    var dayNumber: String = "01"
    var lines: [String]

    init() {
        // TODO
        lines = []
        lines = getInputLines()
    }

    func solveDay1() -> Any {
        let sol = lines
            .map { 10 * ($0.firstDigit()?.0 ?? 0) + ($0.lastDigit()?.0 ?? 0)}
            .reduce(0, +)
        return sol
    }

    func solveDay2() -> Any {
        var sum = 0

        for line in lines {
            if line.isEmpty { continue }
            var (firstDigit, firstDigitIndex) = line.firstDigit() ?? (-1, Int.max)
            var (lastDigit, lastDigitIndex) = line.lastDigit() ?? (-1, Int.min)
            
            for (text, value) in numbers {
                if let range = line.range(of: text) {
                    let i = line.distance(from: line.startIndex, to: range.lowerBound)
                    if (i < firstDigitIndex) {
                        (firstDigit, firstDigitIndex) = (value, i)
                    }
                }

                let lineReversed = String(line.reversed())
                if let range = lineReversed.range(of: String(text.reversed())) {
                    let i = line.distance(from: range.lowerBound, to: lineReversed.endIndex)
                    if (i > lastDigitIndex) {
                        (lastDigit, lastDigitIndex) = (value, i)
                    }
                }

            }
            sum += 10 * firstDigit + lastDigit
        }
        return sum
    }
}

fileprivate extension String {
    func firstDigit() -> (Int, Int)? {
        for (i, character) in self.enumerated() {
            if let v = character.wholeNumberValue {
                return (v, i)
            }
        }
        return nil
    }

    func lastDigit() -> (Int, Int)? {
        for (i, character) in self.reversed().enumerated() {
            if let v = character.wholeNumberValue {
                return (v, self.count - i - 1)
            }
        }
        return nil
    }
}