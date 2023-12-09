class Day09: AdventDay {
  let sequences: [[Int]]

  init() {
    self.sequences = Self.dataLines.map { line in
      return line.split(separator: " ").map { Int($0)! }
    }
  }

  func extrapolate(seq: [Int]) -> Int {
    if seq.allSatisfy({ $0 == 0 }) {
      return 0
    }
    return seq.last! + extrapolate(seq: seq.differenceSequence)
  }

  func part1() -> Any {
    self.sequences
      .map(extrapolate)
      .reduce(0, +)
  }

  func part2() -> Any {
    self.sequences
      .map { $0.reversed() }
      .map(extrapolate)
      .reduce(0, +)
  }
}

extension Array where Element == Int {
  var differenceSequence: [Int] {
    return zip(self[1...], self).map { $0 - $1 }
  }
}
