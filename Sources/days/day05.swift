class Day05: AdventDay {
    let seeds: [Int]
    let maps: [[ClosedRange<Int>: ClosedRange<Int>]]

    init() {
        let lines = Self.dataLines
        self.seeds = lines[0].split(separator: ":")[1].split(separator: " ").map { Int($0)! }
        var maps: [[ClosedRange<Int>: ClosedRange<Int>]] = []

        var currentMap: [ClosedRange<Int>: ClosedRange<Int>] = [:]
        for line in Self.dataLines[1...] {
            switch true {
                case line.isEmpty:
                    continue
                case line.contains("map"):
                    if !currentMap.isEmpty {
                        maps.append(currentMap)
                    }
                    currentMap = [:]
                default:
                    let nums = line.split(separator: " ")
                    let (dest, source, length) = (Int(nums[0])!, Int(nums[1])!, Int(nums[2])!)
                    let sourceRange = source ... source + length - 1
                    let destRange = dest ... dest + length - 1
                    currentMap[sourceRange] = destRange
            }

        }
        if !currentMap.isEmpty {
            maps.append(currentMap)
        }
        self.maps = maps
    }

    func findDestination(seed: Int) -> Int {
        var currentValue = seed
        for map in self.maps {
            let matchingRange = map.first { $0.key.contains(currentValue) }
            if let (source, dest) = matchingRange {
                currentValue = (currentValue - source.lowerBound) + dest.lowerBound
            }
        }
        return currentValue
    }

    func part1() -> Any {
        return seeds
            .map { findDestination(seed: $0)}
            .min()!
    }

    func part2() -> Any {
        // It's stupid but I have work to do so this can process in background while I'm busy :))
        // EDIT: took 6 minutes only with release build!

        var seedRanges: [ClosedRange<Int>] = []
        for i in 0 ..< seeds.count / 2 {
            let start = seeds[2*i]
            let length = seeds[2*i + 1]
            seedRanges.append(start ... start + length - 1)
        }
        
        var minDest = Int.max
        for range in seedRanges {
            for seed in range {
                let destination = findDestination(seed: seed)
                minDest = min(destination, minDest)
            }
        }
        return minDest
    }
}