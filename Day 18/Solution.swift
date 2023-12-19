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
    var upLeft: Self { .init(x: x - 1, y: y - 1) }
    var upRight: Self { .init(x: x + 1, y: y - 1) }
    var downLeft: Self { .init(x: x - 1, y: y + 1) }
    var downRight: Self { .init(x: x + 1, y: y + 1) }

    var adjacent: [Self] { [upLeft, up, upRight, left, right, downLeft, down, downRight] }
}

enum Part1 {
    static func floodFill(from start: Coordinate, initial filled: Set<Coordinate>) -> Set<Coordinate> {
        var filled = filled
        var queue: Set<Coordinate> = [start]
        while queue.isEmpty == false {
            let coord = queue.removeFirst()
            coord.adjacent.forEach { next in
                if filled.contains(next) == false && queue.contains(next) == false {
                    filled.insert(next)
                    queue.insert(next)
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

struct Edge {
    let xRange: ClosedRange<Int>
    let yRange: ClosedRange<Int>
    var length: Int { (xRange.count > 1 ? xRange.count : yRange.count) - 1 }
    var isVertical: Bool { yRange.count > 1 }
    init(_ start: Coordinate, _ end: Coordinate) {
        self.xRange = min(start.x, end.x) ... max(start.x, end.x)
        self.yRange = min(start.y, end.y) ... max(start.y, end.y)
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        var coord = Coordinate.origin
        let edges: [Edge] = source.lines.reduce(into: []) { result, line in
            let parts = line.split(separator: " ")
            let dirInt = Int(String(parts[2].dropFirst(7).dropLast()))!
            let count = Int(String(parts[2].dropFirst(2).dropLast(2)), radix: 16)!
            let end =
                switch dirInt {
                case 0: Coordinate(x: coord.x + count, y: coord.y)
                case 1: Coordinate(x: coord.x, y: coord.y + count)
                case 2: Coordinate(x: coord.x - count, y: coord.y)
                case 3: Coordinate(x: coord.x, y: coord.y - count)
                default: fatalError()
                }
            result.append(Edge(coord, end))
            coord = end
        }

        let rows: [Int: [Int]] = edges.reduce(into: [:]) { result, edge in
            if edge.isVertical {
                for y in edge.yRange.dropLast() {
                    result[y, default: []].append(edge.xRange.lowerBound)
                }
            }
        }

        let fillCount = rows.values.reduce(into: 0) { result, row in
            let columns = row.sorted()
            assert(columns.count >= 2 && columns.count.isMultiple(of: 2))
            for idx in stride(from: 0, to: columns.count - 1, by: 2) {
                result += columns[idx + 1] - columns[idx]
            }
        }

        let perimeter = edges.reduce(0) { $0 + $1.length }

        print("Part 2 (\(source)): \(fillCount + perimeter / 2 + 1)")
    }
}
