class Day11: AdventDay {
  fileprivate let universe: [[Tile]]
  fileprivate let galaxies: [Point]
  fileprivate let emptyRows: [Int]
  fileprivate let emptyCols: [Int]

  init() {
    let universe = Self.dataLines.map { line in
      return line.map { Tile($0) }
    }

    self.emptyRows =
      universe
      .enumerated()
      .filter { (_, line) in
        line.allSatisfy { $0 == .space }
      }
      .map { $0.0 }

    self.emptyCols = universe[0].indices
      .compactMap { col in
        for row in universe.indices {
          if universe[row][col] == .galaxy {
            return nil
          }
        }
        return col
      }

    var galaxies: [Point] = []
    for row in universe.indices {
      for col in universe[0].indices {
        if universe[row][col] == .galaxy {
          galaxies.append(Point(row: row, col: col))
        }
      }
    }

    self.universe = universe
    self.galaxies = galaxies
  }

  fileprivate var galaxyPairs: [(Point, Point)] {
    var galaxies: [(Point, Point)] = []
    for i in 0..<self.galaxies.count {
      for j in 0...i {
        galaxies.append((self.galaxies[i], self.galaxies[j]))
      }
    }
    return galaxies
  }

  func getDistanceSum(emptySpaceMultiplier mul: Int) -> Int {
    var sum = 0
    for (g1, g2) in self.galaxyPairs {
      if g1 == g2 { continue }
      let (dx, dy) = (abs(g1.col - g2.col), abs(g1.row - g2.row))
      let expandedCols = self.emptyCols.filter { $0 > min(g1.col, g2.col) && $0 < (max(g1.col, g2.col)) }.count
      let expandedRows = self.emptyRows.filter { $0 > min(g1.row, g2.row) && $0 < (max(g1.row, g2.row)) }.count
      sum += (dx - expandedCols) + (dy - expandedRows) + (expandedCols + expandedRows) * mul
    }
    return sum
  }

  func part1() -> Any {
    return getDistanceSum(emptySpaceMultiplier: 2)
  }

  func part2() -> Any {
    return getDistanceSum(emptySpaceMultiplier: 1_000_000)
  }
}

private enum Tile: CustomStringConvertible {
  case galaxy, space

  init(_ c: Character) {
    switch c {
    case ".": self = .space
    case "#": self = .galaxy
    default: fatalError("its bad")
    }
  }

  var description: String {
    switch self {
    case .galaxy: return "#"
    case .space: return "."
    }
  }
}

private struct Point: Equatable {
  let row: Int
  let col: Int
}
