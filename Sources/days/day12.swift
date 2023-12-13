class Day12: AdventDay {
  fileprivate let records: [Record]

  init() {
    self.records = Self.dataLines.map { line in
      let x = line.split(separator: " ")
      let springs = x[0].map(Spring.init)
      let groups = x[1].split(separator: ",").map { Int($0)! }
      return Record(springs: springs, groups: groups)
    }
  }

  fileprivate func figureOutArrangements(of record: Record) -> Int {
    var sum = 0

    func inner(_ r: Record) {
      if !r.isPossible {
        return
      }
      if r.isFinal {
        if r.isValid {
          sum += 1
        }
        return
      }

      inner(r.changeFirstUnknown(to: .operational))
      inner(r.changeFirstUnknown(to: .damaged))

    }

    inner(record)

    return sum
  }

  func part1() -> Any {
    var s = 0
    for record in records {
      s += figureOutArrangements(of: record)
    }
    return s
  }

  func part2() -> Any {
    return ""
  }
}

private struct Record {
  let springs: [Spring]
  let groups: [Int]

  var expectedDamagedCount: Int {
    groups.reduce(0, +)
  }

  var longestGroup: Int {
    groups.max()!
  }

  var isFinal: Bool {
    !springs.contains(.unknown)
  }

  var isPossible: Bool {
    let x = self.springs.split(separator: .operational)
    let currentGroups = x.map({ $0.split(separator: .unknown) }).flatMap { $0 }

    var i = 0
    var copyGroups = groups
    for currentGroup in currentGroups {
      var found = false
      while i < copyGroups.count {
        if currentGroup.count <= copyGroups[i] {
          copyGroups[i] -= (currentGroup.count + 1)  // +1 becuase of the gap!
          found = true
          break
        } else {
          i += 1
        }
      }

      if !found {
        return false
      }
    }

    return true
  }

  var isValid: Bool {
    if !isFinal {
      return false
    }
    return self.springs.split(separator: .operational).map(\.count) == groups
  }

  func changeFirstUnknown(to s: Spring) -> Record {
    let i = springs.firstIndex(where: { $0 == .unknown })!
    var c = springs
    c[i] = s
    return Record(springs: c, groups: groups)
  }

}

private enum Spring: CustomStringConvertible {
  case operational, damaged, unknown

  init(_ c: Character) {
    switch c {
    case ".": self = .operational
    case "#": self = .damaged
    case "?": self = .unknown
    default: fatalError("its bad")
    }
  }

  var description: String {
    switch self {
    case .operational: return "."
    case .damaged: return "#"
    case .unknown: return "?"
    }
  }

}
