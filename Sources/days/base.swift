import Foundation

protocol AdventDay {
    var dayNumber: String { get }
    func readInput() -> String
    func getInputLines() -> [String]

    func solveDay1() -> Any
    func solveDay2() -> Any
}

extension AdventDay {
    func readInput() -> String {
        return try! String(contentsOfFile: "./Sources/InputData/day\(dayNumber).txt")
    }

    func getInputLines() -> [String] {
        return readInput().components(separatedBy: "\n")
    }

}