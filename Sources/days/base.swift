import Foundation

protocol AdventDay {

    static var day: String { get }
    var data: String { get }
    var dataLines: [String] { get}

    func part1() -> Any
    func part2() -> Any
}

extension AdventDay {

    var data: String {
        return try! String(contentsOfFile: "./Sources/Data/day\(Self.day).txt")
    }

    var dataLines: [String] {
        data.components(separatedBy: "\n")
    }

    static var day: String {
        let name = String(describing: type(of: self))
        return name.filter{ $0.isWholeNumber }
    }

}