class Day16: AdventDay {
  fileprivate let layout: [[Tile]]

  init() {
    self.layout = Self.dataLines.map { line in
      return line.map(Tile.init)
    }
  }

  fileprivate func outOfBounds(_ p: Point) -> Bool {
    return p.row < 0 || p.row > layout.count - 1 || p.col < 0 || p.col > layout[0].count - 1
  }

  fileprivate func energizedCount(startingBeam: Beam) -> Int {
    var beams: [Beam] = [startingBeam]
    var visited: Set<Beam> = .init()
    while !beams.isEmpty {
      var newBeams: [Beam] = []
      for i in beams.indices {
        if visited.contains(beams[i]) || outOfBounds(beams[i].position) {
          continue
        }
        visited.insert(beams[i])

        switch layout[beams[i].position] {
        case .empty: break
        case .mirrorUpRight:
          switch beams[i].direction {
          case .up: beams[i].direction = .left
          case .right: beams[i].direction = .down
          case .left: beams[i].direction = .up
          case .down: beams[i].direction = .right
          }
        case .mirrorUpLeft:
          switch beams[i].direction {
          case .up: beams[i].direction = .right
          case .left: beams[i].direction = .down
          case .right: beams[i].direction = .up
          case .down: beams[i].direction = .left
          }

        case .splitterVertical:
          switch beams[i].direction {
          case .left, .right:
            beams[i].direction = .up
            newBeams.append(Beam(direction: .down, position: beams[i].position))
          case .up, .down: break
          }
        case .splitterHorizontal:
          switch beams[i].direction {
          case .up, .down:
            beams[i].direction = .left
            newBeams.append(Beam(direction: .right, position: beams[i].position))
          case .left, .right: break
          }
        }

        beams[i].move()
        newBeams.append(beams[i])
      }

      beams = newBeams
    }

    return Set(visited.map({ $0.position })).count
  }

  func part1() -> Any {
    return energizedCount(startingBeam: Beam(direction: .right, position: Point(row: 0, col: 0)))
  }

  func part2() -> Any {
    var maximum = Int.min
    for row in 0..<layout.count {
      let b1 = Beam(direction: .right, position: Point(row: row, col: 0))
      let r1 = energizedCount(startingBeam: b1)
      let b2 = Beam(direction: .left, position: Point(row: row, col: layout[0].count - 1))
      let r2 = energizedCount(startingBeam: b2)
      maximum = max(r1, r2, maximum)
    }
    for col in 0..<layout[0].count {
      let b1 = Beam(direction: .down, position: Point(row: 0, col: col))
      let r1 = energizedCount(startingBeam: b1)
      let b2 = Beam(direction: .up, position: Point(row: layout.count - 1, col: col))
      let r2 = energizedCount(startingBeam: b2)
      maximum = max(r1, r2, maximum)
    }

    return maximum
  }
}

private struct Point: Hashable {
  var row: Int
  var col: Int

  mutating func move(_ d: Direction) {
    switch d {
    case .up: row -= 1
    case .down: row += 1
    case .left: col -= 1
    case .right: col += 1
    }
  }

}

private struct Beam: Hashable {
  var direction: Direction
  var position: Point

  mutating func move() {
    self.position.move(direction)
  }

}

private enum Tile: CustomStringConvertible {
  case empty, mirrorUpRight, mirrorUpLeft, splitterVertical, splitterHorizontal

  init(_ c: Character) {
    switch c {
    case ".": self = .empty
    case "/": self = .mirrorUpLeft
    case "\\": self = .mirrorUpRight
    case "|": self = .splitterVertical
    case "-": self = .splitterHorizontal
    default: fatalError("its bad")
    }
  }

  var description: String {
    switch self {
    case .empty: return "."
    case .mirrorUpRight: return "/"
    case .mirrorUpLeft: return "\\"
    case .splitterVertical: return "|"
    case .splitterHorizontal: return "-"
    }
  }

}

private enum Direction: Hashable {
  case up, down, left, right
}

extension [[Tile]] {
  fileprivate subscript(_ p: Point) -> Tile {
    return self[p.row][p.col]
  }
}
