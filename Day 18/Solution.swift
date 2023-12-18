//
//  Solution.swift
//  Day 18
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

    var description: String { "(\(x), \(y))" }

    var up: Self { .init(x: x, y: y - 1) }
    var down: Self { .init(x: x, y: y + 1) }
    var left: Self { .init(x: x - 1, y: y) }
    var right: Self { .init(x: x + 1, y: y) }

    var allDirections: [Self] { [left, up, right, down] }
}

enum Part1 {
    static func floodFill(from start: Coordinate, initial filled: Set<Coordinate>) -> Set<Coordinate> {
        var filled = filled
        var queue = [start]
        while queue.isEmpty == false {
            let coord = queue.removeFirst()
            coord.allDirections.forEach { next in
                if filled.contains(next) == false {
                    filled.insert(next)
                    queue.append(next)
                }
            }
        }
        return filled
    }

    static func run(_ source: InputData) {
        var lagoon: [Coordinate: String] = [.origin: ""]
        var coord = Coordinate.origin
        for line in source.lines {
            let parts = line.split(separator: " ").map(String.init)
            let dir =
                switch parts[0] {
                case "L": \Coordinate.left
                case "R": \Coordinate.right
                case "U": \Coordinate.up
                case "D": \Coordinate.down
                default: fatalError()
                }
            let count = Int(parts[1])!
            for _ in 1 ... count {
                coord = coord[keyPath: dir]
                lagoon[coord] = parts[2]
            }
        }
        let filled = floodFill(from: .init(x: 1, y: 1), initial: .init(lagoon.keys))

        print("Part 1 (\(source)): \(filled.count)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
