private typealias Step = (Point, Direction)

class Day10: AdventDay {
  fileprivate var grid: [[Tile]]
  fileprivate let startingPosition: Point

  init() {
    self.grid = Self.dataLines.map { line in
      print(line)
      return line.map { char in Tile(char) }
    }

    let row = self.grid.firstIndex { $0.contains(.start) }!
    let col = self.grid[row].firstIndex(of: .start)!

    self.startingPosition = Point(row, col)
  }

  fileprivate func grid(_ p: Point) -> Tile {
    grid[p.row][p.col]
  }

  fileprivate func findLoop() -> [(Tile, Point)] {
    let startingSteps: [Step] = [
      (self.startingPosition + Point(-1, 0), .nort)
      // (self.startingPosition + Point(1, 0), .sout)
      // (self.startingPosition + Point(0, -1), .west)
      // (self.startingPosition + Point(0, 1), .east),
    ]

    for startingStep in startingSteps {
      var currentLoop: [(Tile, Point)] = [(.start, startingPosition)]
      var nextStep = startingStep
      while true {
        let tile = grid(nextStep.0)
        currentLoop.append((tile, nextStep.0))
        if tile == .start || tile == .ground {
          break
        }
        let x = tile.flction(comingFrom: nextStep)
        if let x {
          nextStep = x
        } else {
          break
        }
      }

      if currentLoop.first!.0 == .start && currentLoop.last!.0 == .start {
        return currentLoop
      }
    }
    return []
  }

  func part1() -> Any {
    let loop = findLoop()
    return (loop.count) / 2
  }

  fileprivate func getEnclosingGrid(grid: [[Tile]]) -> [[TileRegion]] {
    let (height, width) = (grid.count, grid[0].count)
    var enclosedGrid: [[TileRegion?]] = .init(
      repeating: .init(repeating: nil, count: grid[0].count), count: grid.count)

    enclosedGrid = grid.map { line in
      return line.map { $0 != .ground ? TileRegion.pipe($0) : nil }
    }

    func outOfBounds(_ y: Int, _ x: Int) -> Bool {
      return y < 0 || x < 0 || y > height - 1 || x > width - 1
    }

    func flood(_ startY: Int, _ startX: Int) {
      var nodes: [(Int, Int)] = [(startY, startX)]

      while !nodes.isEmpty {
        let (y, x) = nodes.removeFirst()
        if outOfBounds(y, x) || enclosedGrid[y][x] != nil {
          continue
        }
        enclosedGrid[y][x] = .outside
        nodes.append(contentsOf: [
          (y - 1, x + 0),
          (y + 1, x + 0),
          (y + 0, x + 1),
          (y + 0, x + -1),
        ])
      }
    }

    flood(0, 0)
    return enclosedGrid.map { line in line.map { $0 != nil ? $0! : .inside } }
  }

  fileprivate func expandGrid(grid: [[Tile]]) -> [[Tile]] {
    var newGrid: [[Tile]] = .init(
      repeating: .init(repeating: .ground, count: grid[0].count * 3), count: grid.count * 3)

    for (j, row) in grid.enumerated() {
      for (i, element) in row.enumerated() {
        let y = 3 * j
        let x = 3 * i

        for jj in 0...2 {
          for ii in 0...2 {
            newGrid[y + jj][x + ii] = Tile(
              element.expanded.components(separatedBy: .whitespacesAndNewlines)[jj][ii])
          }
        }
      }
    }

    return newGrid
  }

  func part2() -> Any {
    let points = findLoop().map { $0.1 }

    for j in grid.indices {
      for i in grid[0].indices {
        if !points.contains(where: { $0 == Point(j, i) }) {
          grid[j][i] = .ground
        }
      }
    }

    grid[startingPosition.row][startingPosition.col] = .init("L")
    let enclosingGrid = getEnclosingGrid(grid: expandGrid(grid: grid))

    // enclosingGrid.forEach {
    //   print($0)
    // }

    var sum = 0
    let (height, width) = (enclosingGrid.count, enclosingGrid[0].count)
    var (y, x) = (1, 1)
    while true {
      var isInside = true
      for (i, j) in zip(-1...1, -1...1) {
        if enclosingGrid[y + i][x + j] != .inside {
          isInside = false
          break
        }
      }

      if isInside {
        sum += 1
      }
      (y, x) = x > width - 3 ? (y + 3, 1) : (y, x + 3)
      if y > height - 3 && x > width - 3 {
        break
      }
    }

    return sum
  }

}

private enum Tile: Equatable, CustomStringConvertible {
  case NS, EW, NE, NW, SW, SE, ground, start
  init(_ char: Character) {
    switch char {
    case "|": self = .NS
    case "-": self = .EW
    case "L": self = .NE
    case "J": self = .NW
    case "7": self = .SW
    case "F": self = .SE
    case ".": self = .ground
    case "S": self = .start
    default: fatalError("its bad")
    }
  }

  var description: String {
    switch self {
    case .NS: return "|"
    case .EW: return "-"
    case .NE: return "L"
    case .NW: return "J"
    case .SW: return "7"
    case .SE: return "F"
    case .ground: return "."
    case .start: return "S"
    }
  }

  func flction(comingFrom: Step) -> Step? {
    let (p, direction) = comingFrom
    switch self {
    case .NS:
      switch direction {
      case .nort: return p.move(.nort)
      case .sout: return p.move(.sout)
      default: return nil
      }

    case .EW:
      switch direction {
      case .west: return p.move(.west)
      case .east: return p.move(.east)
      default: return nil
      }
    case .NE:
      switch direction {
      case .sout: return p.move(.east)
      case .west: return p.move(.nort)
      default: return nil
      }
    case .NW:
      switch direction {
      case .sout: return p.move(.west)
      case .east: return p.move(.nort)
      default: return nil
      }
    case .SW:
      switch direction {
      case .nort: return p.move(.west)
      case .east: return p.move(.sout)
      default: return nil
      }
    case .SE:
      switch direction {
      case .nort: return p.move(.east)
      case .west: return p.move(.sout)
      default: return nil
      }
    default: fatalError("its bad ")
    }
  }

}

private enum Direction: Equatable {
  case nort
  case sout
  case west
  case east
}

private struct Point: Equatable {
  let row: Int
  let col: Int

  init(_ row: Int, _ col: Int) {
    self.row = row
    self.col = col
  }

  func move(_ dir: Direction) -> Step {
    switch dir {
    case .nort: return (Point(row - 1, col + 0), .nort)
    case .sout: return (Point(row + 1, col + 0), .sout)
    case .west: return (Point(row + 0, col - 1), .west)
    case .east: return (Point(row + 0, col + 1), .east)
    }
  }

  static func + (lhs: Point, rhs: Point) -> Point {
    return Point(lhs.row + rhs.row, lhs.col + rhs.col)
  }

}

private enum TileRegion: CustomStringConvertible, Equatable {
  case inside, outside
  case pipe(Tile)

  var description: String {
    switch self {
    case .inside: return "I"
    case .outside: return "O"
    case .pipe: return "-"
    }
  }
}

extension Tile {
  var expanded: String {
    switch self {

    case .NS:
      return
        """
        .|.
        .|.
        .|.
        """

    case .EW:
      return
        """
        ...
        ---
        ...
        """

    case .NE:
      return
        """
        .|.
        .L-
        ...
        """

    case .NW:
      return
        """
        .|.
        -J.
        ...
        """

    case .SW:
      return
        """
        ...
        -7.
        .|.
        """

    case .SE:
      return
        """
        ...
        .F-
        .|.
        """

    case .ground:
      return
        """
        ...
        ...
        ...
        """

    case .start:
      return
        """
        SSS
        SSS
        SSS
        """
    }
  }
}
