fileprivate enum Cube {
  case red, green, blue
  var limit: Int {
    switch self {
    case .red: return 12
    case .green: return 13
    case .blue: return 14
    }
  }

  init(s: String) {
    switch s {
    case "red": self = .red
    case "green": self = .green
    case "blue": self = .blue
    default:
      fatalError("its bad")
    }
  }

}

class Day02: AdventDay {

  func part1() -> Any {
    var result = 0

    for line in Self.dataLines {
      var limits: [Cube: Int] = [.red: 0, .green: 0, .blue: 0]
      var possible = true

      let s = line.split(separator: ":")
      let gameId = s[0].extractNumber()
      for gameSet in s[1].split(separator: ";") {
        if !possible { break }

        let x = gameSet.split(separator: ",").map { text in
          let x = text.split(separator: " ")
          return (Int(x[0])!, Cube(s: String(x[1])))
        }

        for (number, cube) in x {
          if number > cube.limit {
            possible = false
            break
          }
          limits[cube]! += number
        }
      }

      if possible {
        result += gameId
      }
    }
    return result
  }

  func part2() -> Any {
    var result = 0

    for line in Self.dataLines {
      var maxs: [Cube: Int] = [.red: Int.min, .green: Int.min, .blue: Int.min]

      let s = line.split(separator: ":")
      for gameSet in s[1].split(separator: ";") {
        let x = gameSet.split(separator: ",").map { text in
          let color =
            text.contains("red") ? Cube.red : (text.contains("green") ? Cube.green : Cube.blue)
          return (color, text.extractNumber())
        }

        for (color, number) in x {
          maxs[color] = max(maxs[color]!, number)
        }
      }

      result += maxs.values.reduce(1, *)

    }
    return result
  }
}

extension StringProtocol {
  fileprivate func extractNumber() -> Int {
    Int(String(self.filter { $0.isWholeNumber }))!
  }
}
