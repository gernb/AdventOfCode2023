//
//  Solution.swift
//  Day 10
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Tile: Character {
    case vertical = "|"
    case horizontal = "-"
    case northEastBend = "L"
    case northWestBend = "J"
    case southWestBend = "7"
    case southEastBend = "F"
    case ground = "."
    case start = "S"

    func connections(from coord: Coordinate) -> [Coordinate] {
        switch self {
        case .vertical: [coord.up, coord.down]
        case .horizontal: [coord.left, coord.right]
        case .northEastBend: [coord.up, coord.right]
        case .northWestBend: [coord.up, coord.left]
        case .southWestBend: [coord.left, coord.down]
        case .southEastBend: [coord.right, coord.down]
        case .ground, .start: []
        }
    }
}

struct Coordinate: Hashable {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

    var up: Self { .init(x: x, y: y - 1) }
    var down: Self { .init(x: x, y: y + 1) }
    var left: Self { .init(x: x - 1, y: y) }
    var right: Self { .init(x: x + 1, y: y) }

    var adjacent: [Self] { [up, left, right, down] }
}

func loadTiles(from lines: [String]) -> [Coordinate: Tile] {
    var tiles: [Coordinate: Tile] = [:]
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            tiles[.init(x: x, y: y)] = Tile(rawValue: char)!
        }
    }
    return tiles
}

enum Part1 {
    static func connections(from start: Coordinate, in tiles: [Coordinate: Tile]) -> [Coordinate] {
        start.adjacent.filter { coord in
            guard let tile = tiles[coord] else { return false }
            return tile.connections(from: coord).contains(start)
        }
    }

    static func run(_ source: InputData) {
        let tiles = loadTiles(from: source.data)
        let start = tiles.first(where: { $1 == .start })!.key
        var count = 1
        var visited: Set<Coordinate> = [start]
        var coord = connections(from: start, in: tiles).first
        while let next = coord {
            count += 1
            visited.insert(next)
            coord = tiles[next]!.connections(from: next).filter { visited.contains($0) == false }.first
        }

        print("Part 1 (\(source)): \(count / 2)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}
