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

func parseGrid<Tile>(from lines: [String], using builder: (Coordinate, Character) -> Tile?) -> [Coordinate: Tile] {
    lines.enumerated().reduce(into: [:]) { result, pair in
        let y = pair.offset
        result = pair.element.enumerated().reduce(into: result) { result, pair in
            let coord = Coordinate(x: pair.offset, y: y)
            result[coord] = builder(coord, pair.element)
        }
    }
}

func dfs<Node: Hashable>(start: Node, to end: Node, using getNextNodes: (Node) -> [(Node, Int)]) -> Int {
    dfs(start: start, to: [end], using: getNextNodes).values.first!
}

func dfs<Node: Hashable>(start: Node, to ends: Set<Node>, using getNextNodes: (Node) -> [(Node, Int)]) -> [Node: Int] {
    var maxDistances: [Node: Int] = [:]
    var visited: Set<Node> = []

    @discardableResult
    func traverse(from node: Node, distance: Int) -> [Node: Int] {
        if distance > 1 && ends.contains(node) {
            let previous = maxDistances[node, default: 0]
            maxDistances[node] = max(previous, distance)
            return maxDistances
        }
        visited.insert(node)
        for next in getNextNodes(node).filter({ visited.contains($0.0) == false }) {
            traverse(from: next.0, distance: distance + next.1)
        }
        visited.remove(node)
        return maxDistances
    }

    return traverse(from: start, distance: 0)
}

extension String {
    func firstIndex(of char: Character) -> Int? {
        self.firstIndex(of: char)?.utf16Offset(in: self)
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let map = parseGrid(from: source.lines) { Tile($1) }
        let trailEntrance = Coordinate(x: source.lines.first!.firstIndex(of: ".")!, y: 0)
        let trailExit = Coordinate(x: source.lines.last!.firstIndex(of: ".")!, y: source.lines.count - 1)

        let result = dfs(start: trailEntrance, to: trailExit) { coord in
            coord.neighbours.filter {
                switch map[$0] {
                case .path: true
                case .slope("<"): $0 == coord.left
                case .slope(">"): $0 == coord.right
                case .slope("^"): $0 == coord.up
                case .slope("v"): $0 == coord.down
                case .forest, .none: false
                default: fatalError()
                }
            }
            .map { ($0, 1) }
        }

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let map = parseGrid(from: source.lines) { Tile($1) }
        let trailEntrance = Coordinate(x: source.lines.first!.firstIndex(of: ".")!, y: 0)
        let trailExit = Coordinate(x: source.lines.last!.firstIndex(of: ".")!, y: source.lines.count - 1)

        let junctions: [Coordinate] = map.reduce(into: []) { result, pair in
            guard pair.value != .forest else { return }
            if pair.key == trailEntrance || pair.key == trailExit {
                result.append(pair.key)
            } else if pair.key.neighbours.filter({ map[$0] != .forest }).count > 2 {
                result.append(pair.key)
            }
        }

        let pathsBetweenJunctions = junctions.reduce(into: [:]) { result, junction in
            result[junction] = dfs(start: junction, to: Set(junctions)) { coord in
                coord.neighbours.filter { map[$0, default: .forest] != .forest }.map { ($0, 1) }
            }
            .map { (end: $0.key, distance: $0.value) }
        }

        let result = dfs(start: trailEntrance, to: trailExit, using: { pathsBetweenJunctions[$0]! })
        print("Part 2 (\(source)): \(result)")
    }
}
