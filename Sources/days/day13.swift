class Day13: AdventDay {
  fileprivate let maps: [Map]

  init() {
    self.maps = Self.dataLines
      .split(whereSeparator: { $0.isEmpty })
      .map { lines in
        return Map(tiles: lines.map { line in line.map(Tile.init) })
      }
  }

  fileprivate func hasReflection(map: Map, inRow row: Int) -> Bool {
    var (i, j) = (row - 1, row)
    while !(i < 0 || j > map.rows - 1) {
      if map.tiles[i] != map.tiles[j] {
        return false
      }
      (i, j) = (i - 1, j + 1)
    }
    return true
  }

  fileprivate func hasReflectionWithSmudge(map: Map, inRow row: Int) -> Bool {
    var (i, j) = (row - 1, row)
    var foundSmudged = false
    while !(i < 0 || j > map.rows - 1) {

      if map.tiles[i] != map.tiles[j] {
        let diffs = zip(map.tiles[i], map.tiles[j]).map({ $0 != $1 }).filter { $0 == true }
        if foundSmudged || diffs.count > 1 {
          return false
        }

        foundSmudged = true
      }
      (i, j) = (i - 1, j + 1)
    }
    return true
  }

  fileprivate func horizontalReflections(map: Map, withSmudges: Bool) -> Int {
    var sum = 0
    let reflectionFunction = withSmudges ? hasReflectionWithSmudge : hasReflection
    for row in 1..<map.rows {
      if reflectionFunction(map, row) {
        sum += row
      }
    }
    return sum
  }

  fileprivate func verticalReflections(map: Map, withSmudges: Bool) -> Int {
    return horizontalReflections(map: map.transposed(), withSmudges: withSmudges)
  }

  func getReflectionsSum(withSmudges: Bool) -> Int {
    var s = 0
    for map in maps {
      let v = verticalReflections(map: map, withSmudges: withSmudges)
      let h = 100 * horizontalReflections(map: map, withSmudges: withSmudges)
      s += v + h
    }
    return s
  }

  func part1() -> Any {
    return getReflectionsSum(withSmudges: false)
  }

  func part2() -> Any {
    return getReflectionsSum(withSmudges: true) - getReflectionsSum(withSmudges: false)
  }
}

private struct Map {
  fileprivate let tiles: [[Tile]]
  var rows: Int { tiles.count }
  var cols: Int { tiles[0].count }

  func transposed() -> Map {
    guard let first = self.tiles.first else { return Map(tiles: []) }
    let newTiles = first.indices.map { index in
      self.tiles.map { $0[index] }
    }
    return Map(tiles: newTiles)
  }

  func copy(swapAt pos: (row: Int, col: Int)?) -> Map {
    var t = tiles
    if let pos {
      t[pos.row][pos.col] = t[pos.row][pos.col].opposite()
    }
    return Map(tiles: t)
  }

}

private enum Tile: CustomStringConvertible {
  case ash, rock
  init(_ c: Character) {
    switch c {
    case ".": self = .ash
    case "#": self = .rock
    default: fatalError("its bad")
    }
  }

  var description: String {
    switch self {
    case .ash: return "."
    case .rock: return "#"
    }
  }

  func opposite() -> Tile {
    switch self {
    case .ash: return .rock
    case .rock: return .ash
    }
  }

}
