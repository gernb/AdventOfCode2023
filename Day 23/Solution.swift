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
        let trailEntrance = Coordinate(x: 1, y: 0)
        let trailExit = Coordinate(x: source.lines[0].count - 2, y: source.lines.count - 1)

        func findAllPaths(from start: Coordinate, visited: Set<Coordinate> = []) -> [Set<Coordinate>] {
            if start == trailExit {
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

        let result = findAllPaths(from: trailEntrance).map(\.count).max()!

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let map = loadTrailMap(source.lines)
        let trailEntrance = Coordinate(x: 1, y: 0)
        let trailExit = Coordinate(x: source.lines[0].count - 2, y: source.lines.count - 1)

        let junctions: [Coordinate] = map.reduce(into: []) { result, pair in
            guard pair.value != .forest else { return }
            if pair.key == trailEntrance || pair.key == trailExit {
                result.append(pair.key)
            } else if pair.key.neighbours.filter({ map[$0] != .forest }).count > 2 {
                result.append(pair.key)
            }
        }

        func findLongestDistances(from start: Coordinate, to ends: [Coordinate]) -> [(end: Coordinate, distance: Int)] {
            func findAllDistances(from start: Coordinate, to ends: [Coordinate], path: Set<Coordinate> = []) -> [(end: Coordinate, distance: Int)] {
                let path = path.union([start])
                if ends.contains(start) && path.count > 1 {
                    return [(start, path.count - 1)]
                }
                let next = start.neighbours.filter {
                    guard path.contains($0) == false else { return false }
                    return map[$0, default: .forest] != .forest
                }
                return next.flatMap { findAllDistances(from: $0, to: ends, path: path) }
            }
            return findAllDistances(from: start, to: ends).reduce(into: Dictionary<Coordinate, Int>()) { result, pair in
                let previous = result[pair.end, default: 0]
                result[pair.end] = max(previous, pair.distance)
            }
            .map { ($0.key, $0.value) }
        }

        let trails = junctions.reduce(into: [:]) { result, end in
            result[end] = findLongestDistances(from: end, to: junctions)
        }

        func findLongestTrail(from start: Coordinate, path: [(junction: Coordinate, distance: Int)] = []) -> [(junction: Coordinate, distance: Int)] {
            if start == trailExit {
                return path
            }
            let visited = Set(path.map(\.junction) + [start])
            let nextTrails = trails[start]!
                .filter { visited.contains($0.end) == false }
            return nextTrails.map {
                let nextTrail = findLongestTrail(from: $0.end, path: path + [($0.end, $0.distance)])
                return (trail: nextTrail, distance: nextTrail.reduce(0) { $0 + $1.distance })
            }
            .max(by: { $0.distance < $1.distance })?.trail ?? []
        }

        let longestPath = findLongestTrail(from: trailEntrance)

        print("Part 2 (\(source)): \(longestPath.reduce(0) { $0 + $1.distance })")
    }
}
