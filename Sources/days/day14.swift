class Day14: AdventDay {
  fileprivate let reflectorDish: [[Tile]]

  init() {
    self.reflectorDish = Self.dataLines.map { line in
      return line.map(Tile.init)
    }
  }

  fileprivate func tilt(_ inDish: [[Tile]], towards tilt: Tilt) -> [[Tile]] {
    var dish: [[Tile]]

    switch tilt {
    case .north: dish = inDish.transposed()
    case .west: dish = inDish
    case .south: dish = inDish.transposed().map { $0.reversed() }
    case .east: dish = inDish.map { $0.reversed() }
    }

    var stops = dish.map { line in
      return [-1] + line.enumerated().compactMap { $1 == .cubeRock ? $0 : nil }
    }

    for row in 0..<dish.count {
      for col in 0..<dish[0].count {
        if dish[row][col] == .roundedRock {
          let firstGreatestSmallerIndex = stops[row].lastIndex { $0 < col }!
          stops[row][firstGreatestSmallerIndex] += 1
          dish[row][col] = .empty
          dish[row][stops[row][firstGreatestSmallerIndex]] = .roundedRock
        }

      }
    }

    switch tilt {
    case .north: return dish.transposed()
    case .west: return dish
    case .south: return dish.map({ $0.reversed() }).transposed()
    case .east: return dish.map { $0.reversed() }
    }

  }

  fileprivate func calculateLoad(dish: [[Tile]]) -> Int {
    var s = 0
    for row in dish.transposed() {
      s += row.enumerated()
        .map { (i, tile) in
          return tile == .roundedRock ? (row.count - i) : 0
        }
        .reduce(0, +)
    }
    return s
  }

  fileprivate func rotateBalanga(_ dish: inout [[Tile]]) {
    for t in Tilt.cases {
      dish = tilt(dish, towards: t)
    }
  }

  func part1() -> Any {
    let tilted = tilt(reflectorDish, towards: .north)
    return calculateLoad(dish: tilted)
  }

  func part2() -> Any {
    var dish = reflectorDish
    var known: [String: Int] = [dish.hash: 0]

    let ITERATIONS = 1_000_000_000
    for i in 0..<ITERATIONS {
      rotateBalanga(&dish)

      if let knownIndex = known[dish.hash] {
        let cycleLength = i - knownIndex
        let iterationsLeft = (ITERATIONS - i) % cycleLength
        for _ in 0..<iterationsLeft - 1 {
          rotateBalanga(&dish)
        }
        return calculateLoad(dish: dish)
      }

      known[dish.hash] = i
    }

    return "its bad"
  }
}

private enum Tile: CustomStringConvertible {
  case roundedRock, cubeRock, empty
  init(_ c: Character) {
    switch c {
    case "O": self = .roundedRock
    case "#": self = .cubeRock
    case ".": self = .empty
    default: fatalError("its bad")
    }
  }

  var description: String {
    switch self {
    case .roundedRock: return "O"
    case .cubeRock: return "#"
    case .empty: return "."
    }
  }

}

extension [[Tile]] {
  fileprivate func transposed() -> [[Tile]] {
    guard let first = self.first else { return [[]] }
    return first.indices.map { index in self.map { $0[index] } }
  }

  var hash: String {
    return self.map({ $0.map({ $0.description }).joined(separator: "") }).joined(separator: "_")
  }
}

enum Tilt {
  case north, west, east, south
  static var cases: [Tilt] {
    return [.north, .west, .south, .east]
  }
}
