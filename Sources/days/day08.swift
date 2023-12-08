func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)
    
    while r != 0 {
        (a, b, r) = (b, r, a % b)
    }
    return b
}

func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}

fileprivate let END_NODE = "ZZZ"

class Day08: AdventDay {
    fileprivate let directions: [Direction]
    let nodes: [String: (String, String)]

    init() {
        let lines = Self.dataLines
        self.directions = lines[0].map { Direction(String($0)) }

        var nodes: [String: (String, String)] = [:]
        for line in lines[1...] {
            if line.isEmpty { continue }
            let x = line.split(separator: "=")
            let y = x[1].filter { $0 != "(" && $0 != ")"}.split(separator: ",")
            nodes[String(x[0]).trimmed] = (String(y[0]).trimmed, String(y[1]).trimmed)
        }
        self.nodes = nodes
    }

    private func getNextNode(currentNode: String, direction: Direction) -> String {
        return  direction == .left ? nodes[currentNode]!.0 : nodes[currentNode]!.1
    }

    private func findStepCount(startingNode: String, endCondition: ((String) -> Bool)) -> Int {
        var (steps, di) = (0, 0)
        var currentNode = startingNode
        while !(endCondition(currentNode)) {
            currentNode = getNextNode(currentNode: currentNode, direction: directions[di])
            steps += 1
            di = (di + 1) % directions.count
        }
        return steps
    } 

    func part1() -> Any {
        return findStepCount(startingNode: "AAA", endCondition: {$0 == "ZZZ"})
    }

    func part2() -> Any {
        let currentNodes = nodes.keys.filter { $0.last! == "A" }.map { String($0) }
        let stepCounts = currentNodes.map { node in 
            findStepCount(startingNode: node, endCondition: {$0.last! == "Z"})
        }
        return stepCounts.reduce(1, lcm)
    }
}


fileprivate enum Direction {
    case left, right
    var index: Int { self == .left ? 0 : 1}
    init(_ s: String) {
        switch s {
            case "L": self = .left
            case "R": self = .right
            default: fatalError("its bad")
        }
    }
}

fileprivate extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespaces)
    }
}