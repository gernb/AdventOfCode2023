//
//  Solution.swift
//  Day 14
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Rock: Character {
    case round = "O"
    case cube = "#"
}

enum Direction: CaseIterable {
    case north, west, south, east
}

struct Platform {
    var positions: [[Rock?]]

    var totalLoad: Int {
        let count = positions.count
        return positions.enumerated().reduce(0) { result, pair in
            let load = count - pair.offset
            return result + pair.element.reduce(0) { $0 + ($1 == .round ? load : 0) }
        }
    }

    mutating func tilt(_ direction: Direction) {
        var result = positions
        switch direction {

        case .north:
            for y in 0 ..< positions.count {
                for x in 0 ..< positions[y].count {
                    guard positions[y][x] == .round else { continue }
                    var destination = y - 1
                    while destination >= 0, result[destination][x] == nil {
                        destination -= 1
                    }
                    destination += 1
                    result[y][x] = nil
                    result[destination][x] = .round
                }
            }

        case .south:
            for y in (0 ..< positions.count).reversed() {
                for x in 0 ..< positions[y].count {
                    guard positions[y][x] == .round else { continue }
                    var destination = y + 1
                    while destination < positions.count, result[destination][x] == nil {
                        destination += 1
                    }
                    destination -= 1
                    result[y][x] = nil
                    result[destination][x] = .round
                }
            }

        case .west:
            for x in 0 ..< positions[0].count {
                for y in 0 ..< positions.count {
                    guard positions[y][x] == .round else { continue }
                    var destination = x - 1
                    while destination >= 0, result[y][destination] == nil {
                        destination -= 1
                    }
                    destination += 1
                    result[y][x] = nil
                    result[y][destination] = .round
                }
            }

        case .east:
            for x in (0 ..< positions[0].count).reversed() {
                for y in 0 ..< positions.count {
                    guard positions[y][x] == .round else { continue }
                    var destination = x + 1
                    while destination < positions[0].count, result[y][destination] == nil {
                        destination += 1
                    }
                    destination -= 1
                    result[y][x] = nil
                    result[y][destination] = .round
                }
            }

        }
        positions = result
    }

    func draw() {
        let strings = positions.map { line in
            line.map { rock in
                switch rock {
                case .round: "O"
                case .cube: "#"
                case .none: "."
                }
            }.joined()
        }
        strings.forEach { print($0) }
        print("")
    }
}
extension Platform {
    init(_ lines: [String]) {
        self.init(positions: lines.map { $0.map(Rock.init(rawValue:)) })
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        var platform = Platform(source.lines)
        platform.tilt(.north)

        print("Part 1 (\(source)): \(platform.totalLoad)")
    }
}

// MARK: - Part 2

extension ArraySlice {
    func split() -> (ArraySlice<Element>, ArraySlice<Element>) {
        (self[startIndex ..< startIndex + count / 2], self[startIndex + count / 2 ..< endIndex])
    }
}

enum Part2 {
    static func findPattern(_ loads: [Int]) -> (preamble: [Int], pattern: [Int])? {
        let count = loads.count
        let preambleMax = max(0, count - 100)
        for preambleCount in 0 ..< preambleMax {
            let preamble = loads.prefix(preambleCount)
            let halves = loads.dropFirst(preambleCount).split()
            if halves.0 == halves.1 {
                return (Array(preamble), Array(halves.0))
            }
        }
        return nil
    }

    static func run(_ source: InputData) {
        var platform = Platform(source.lines)

        let count = 1_000_000_000 * Direction.allCases.count

        var preamble: [Int] = []
        var pattern: [Int] = []
        var loads: [Int] = []
        var directionIdx = 0
        while true {
            var direction = Direction.allCases[directionIdx]
            directionIdx = (directionIdx + 1) % Direction.allCases.count
            platform.tilt(direction)
            loads.append(platform.totalLoad)

            direction = Direction.allCases[directionIdx]
            directionIdx = (directionIdx + 1) % Direction.allCases.count
            platform.tilt(direction)
            loads.append(platform.totalLoad)

            if let result = findPattern(loads) {
                preamble = result.preamble
                pattern = result.pattern
                break
            }
        }

        let idx = (count - preamble.count) % pattern.count
        let totalLoad = loads[preamble.count + idx - 1]

        print("Part 2 (\(source)): \(totalLoad)")
    }
}
