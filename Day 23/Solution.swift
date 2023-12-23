//
//  Solution.swift
//  Day 23
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Tile: Equatable {
    case path
    case forest
    case slope(Character)
}
extension Tile {
    init(_ char: Character) {
        switch char {
        case ".": self = .path
        case "#": self = .forest
        case "<", "^", ">", "v": self = .slope(char)
        default: fatalError()
        }
    }
}

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static let start = Self(x: 1, y: 0)

    var description: String { "(\(x), \(y))" }

    var up: Self { .init(x: x, y: y - 1) }
    var down: Self { .init(x: x, y: y + 1) }
    var left: Self { .init(x: x - 1, y: y) }
    var right: Self { .init(x: x + 1, y: y) }

    var neighbours: [Self] { [up, left, right, down] }
}

func loadTrailMap(_ lines: [String]) -> [Coordinate: Tile] {
    var map: [Coordinate: Tile] = [:]
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            map[Coordinate(x: x, y: y)] = Tile(char)
        }
    }
    return map
}

enum Part1 {
    static func run(_ source: InputData) {
        let map = loadTrailMap(source.lines)
        let end = Coordinate(x: source.lines[0].count - 2, y: source.lines.count - 1)

        func findAllPaths(from start: Coordinate, visited: Set<Coordinate>) -> [Set<Coordinate>] {
            if start == end {
                return [visited]
            }
            let next = start.neighbours.filter {
                guard visited.contains($0) == false else { return false }
                return switch map[$0] {
                case .path: true
                case .slope("<"): $0 == start.left
                case .slope(">"): $0 == start.right
                case .slope("^"): $0 == start.up
                case .slope("v"): $0 == start.down
                case .forest, .none: false
                default: fatalError()
                }
            }
            let visited = visited.union([start])
            return next.flatMap { findAllPaths(from: $0, visited: visited) }
        }

        let result = findAllPaths(from: Coordinate.start, visited: []).map(\.count).max()!

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
