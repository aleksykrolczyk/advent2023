class Day15: AdventDay {
  let steps: [String]

  init() {
    self.steps = Self.dataLines[0].split(separator: ",").map { String($0) }
  }

  func getInstructions() -> [(String, Instruction)] {
    return steps.map { step in
      if step.contains("-") {
        return (String(step.dropLast()), .dash)
      } else {
        let x = step.split(separator: "=")
        return (String(x[0]), .equals(Int(x[1])!))
      }
    }
  }

  func hashmap() -> [Int: [(String, Int)]] {
    var baskets: [Int: [(String, Int)]] = [:]
    for i in 0..<256 { baskets[i] = [] }

    for (lens, instruction) in getInstructions() {
      switch instruction {
      case .dash:
        if let index = baskets[lens.hash]!.firstIndex(where: { $0.0 == lens }) {
          baskets[lens.hash]!.remove(at: index)
        }
      case .equals(let val):
        if let index = baskets[lens.hash]!.firstIndex(where: { $0.0 == lens }) {
          baskets[lens.hash]![index] = (lens, val)
        } else {
          baskets[lens.hash]!.append((lens, val))
        }
      }
    }
    return baskets
  }

  func part1() -> Any {
    return steps.map(\.hash).reduce(0, +)
  }

  func part2() -> Any {
    let baskets = hashmap()
    var sum = 0
    for (index, values) in baskets {
      sum += values.enumerated().map({ (index + 1) * ($0 + 1) * $1.1 }).reduce(0, +)
    }

    return sum
  }
}

extension String {
  fileprivate var hash: Int {
    var currentValue = 0
    for character in self {
      currentValue += Int(exactly: character.asciiValue!)!
      currentValue *= 17
      currentValue = currentValue % 256
    }
    return currentValue
  }
}

enum Instruction {
  case dash
  case equals(Int)
}
