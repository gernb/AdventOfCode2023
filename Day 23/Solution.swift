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

        func findAllPaths(from start: Coordinate, visited: Set<Coordinate> = []) -> [Set<Coordinate>] {
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

        let result = findAllPaths(from: Coordinate.start).map(\.count).max()!

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let map = loadTrailMap(source.lines)
        let end = Coordinate(x: source.lines[0].count - 2, y: source.lines.count - 1)

        let splits: [Coordinate] = map.reduce(into: []) { result, pair in
            if pair.key == Coordinate.start || pair.key == end || pair.value == .forest { return }
            let next = pair.key.neighbours.filter { map[$0] != .forest }
            if next.count > 2 {
                result.append(pair.key)
            }
        }
        let nodes = splits + [Coordinate.start, end]

        func findPaths(from start: Coordinate, to nodes: [Coordinate]) -> [(node: Coordinate, distance: Int)] {
            func findPaths(from start: Coordinate, to nodes: [Coordinate], path: [Coordinate] = []) -> [(node: Coordinate, distance: Int)] {
                let path = path + [start]
                if nodes.contains(start) && path.count > 1 {
                    return [(start, path.count - 1)]
                }
                let next = start.neighbours.filter {
                    guard path.contains($0) == false else { return false }
                    return map[$0, default: .forest] != .forest
                }
                return next.flatMap { findPaths(from: $0, to: nodes, path: path) }
            }
            return findPaths(from: start, to: nodes).reduce(into: Dictionary<Coordinate, Int>()) { result, pair in
                let previous = result[pair.node, default: 0]
                result[pair.node] = max(previous, pair.distance)
            }
            .map { ($0.key, $0.value) }
        }

        let paths = nodes.reduce(into: [:]) { result, node in
            result[node] = findPaths(from: node, to: nodes)
        }

        func dfs(from start: Coordinate, path: [(node: Coordinate, distance: Int)] = []) -> [(node: Coordinate, distance: Int)] {
            if start == end {
                return path
            }
            let visited = path.map(\.node) + [start]
            let nextNodes = paths[start]!
                .filter { visited.contains($0.node) == false }
                .sorted(by: { $0.distance > $1.distance })
            return nextNodes.map {
                let path = dfs(from: $0.node, path: path + [$0])
                return (path: path, distance: path.reduce(0) { $0 + $1.distance })
            }
            .max(by: { $0.distance < $1.distance })?.path ?? []
        }

        let longestPath = dfs(from: Coordinate.start)

        print("Part 2 (\(source)): \(longestPath.reduce(0) { $0 + $1.distance })")
    }
}
