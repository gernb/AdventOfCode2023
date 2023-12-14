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

enum Direction {
    case north, south, east, west
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
        assert(direction == .north)
        var result = positions
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
        positions = result
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

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
