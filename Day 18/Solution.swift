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
    var count: Int { xRange.count > 0 ? xRange.count : yRange.count }
    var isVertical: Bool { yRange.count > 0 }
    init(_ start: Coordinate, _ end: Coordinate) {
        self.xRange = min(start.x, end.x) ... max(start.x, end.x)
        self.yRange = min(start.y, end.y) ... max(start.y, end.y)
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        var edges: [Edge] = []
        var coord = Coordinate.origin
        for line in source.lines {
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
            edges.append(Edge(coord, end))
            coord = end
        }

        let xValues = edges.flatMap { [$0.xRange.lowerBound, $0.xRange.upperBound] }.sorted()
        let yValues = edges.flatMap { [$0.yRange.lowerBound, $0.yRange.upperBound] }.sorted()
        let xRange = xValues.first! ... xValues.last!
        let yRange = yValues.first! ... yValues.last!

        var rows: [Int: [Int]] = [:]
        rows.reserveCapacity(yRange.count)
        for edge in edges {
            if edge.isVertical {
                for y in edge.yRange.dropLast() {
                    rows[y, default: []].append(edge.xRange.lowerBound)
                }
            }
        }

        var fillCount = 0
        for y in yRange {
            var columns = rows[y, default: []].sorted()
            guard columns.count >= 2 else { continue }
            assert(columns.count.isMultiple(of: 2))
            for idx in stride(from: 0, to: columns.count - 1, by: 2) {
                fillCount += columns[idx + 1] - columns[idx] + 1
            }
        }

        let perimeter = edges.reduce(0) { $0 + $1.count - 1 }

        print("Part 2 (\(source)): \(fillCount + perimeter / 2 + 1)")
    }
}
