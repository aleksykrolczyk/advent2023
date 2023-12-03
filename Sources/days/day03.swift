class Day03: AdventDay {

  struct Dims {
    let height: Int
    let width: Int
  }

  let matrix: [String]
  let dims: Dims

  init() {
    matrix = Self.dataLines
    dims = Dims(height: matrix.count, width: matrix[0].count)
  }

  private func isValid(row: Int, cols: (Int, Int)) -> Bool {
    for x in max(0, cols.0 - 1)...min(dims.width - 1, cols.1) {
      for y in max(0, row - 1)...min(dims.height - 1, row + 1) {
        let e = matrix[y][x]
        if !e.isWholeNumber && e != "." {
          return true
        }
      }
    }
    return false
  }

  func getNumbersInRow(row: Int) -> [(String, Int)] {
    var numbers: [(String, Int)] = []
    var currentNumber: String? = nil
    for (col, character) in matrix[row].enumerated() {
      if currentNumber == nil && character.isWholeNumber {
        currentNumber = String(character)
        continue
      }
      if currentNumber != nil {
        if character.isWholeNumber {
          currentNumber!.append(character)
        } else {
          numbers.append((currentNumber!, col - currentNumber!.count))
          currentNumber = nil
        }
      }
    }

    if currentNumber != nil {
      numbers.append((currentNumber!, dims.width - currentNumber!.count))
    }

    return numbers
  }

  func part1() -> Any {
    var sum = 0
    for row in matrix.indices {
      let numbers = getNumbersInRow(row: row)
      for number in numbers {
        let isValid = isValid(row: row, cols: (number.1, number.1 + number.0.count))
        if isValid {
          sum += Int(number.0)!
        }
      }

    }

    return sum
  }

  func isAdjacent(number: (String, Int), to gearX: Int) -> Bool {
    let numberRange = number.1...number.1 + number.0.count - 1
    let gearRange = gearX - 1...gearX + 1
    return numberRange.overlaps(gearRange)
  }

  func part2() -> Any {
    var sum = 0
    for (row, line) in matrix.enumerated() {
      let gears = line.enumerated()
        .filter { $1 == "*" }
        .map { $0.offset }
      for gear in gears {
        var numbers = getNumbersInRow(row: row)
        if row > 0 { numbers += getNumbersInRow(row: row - 1) }
        if row < dims.height - 1 { numbers += getNumbersInRow(row: row + 1) }
        let adjacents =
          numbers
          .filter { isAdjacent(number: $0, to: gear) }
          .map { Int($0.0)! }
        if adjacents.count == 2 {
          sum += adjacents.reduce(1, *)
        }
      }
    }
    return sum
  }

}
