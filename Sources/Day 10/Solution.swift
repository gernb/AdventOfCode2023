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

func loadTiles(from lines: [String]) -> (tiles: [Coordinate: Tile], start: Coordinate) {
    var tiles: [Coordinate: Tile] = [:]
    var start: Coordinate = .origin
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            let c = Coordinate(x: x, y: y)
            let tile = Tile(rawValue: char)!
            tiles[c] = tile
            if tile == .start {
                start = c
            }
        }
    }
    return (tiles, start)
}

enum Part1 {
    static func connections(from start: Coordinate, in tiles: [Coordinate: Tile]) -> [Coordinate] {
        start.adjacent.filter { coord in
            guard let tile = tiles[coord] else { return false }
            return tile.connections(from: coord).contains(start)
        }
    }

    static func loopCoordinates(start: Coordinate, tiles: [Coordinate: Tile]) -> Set<Coordinate> {
        var visited: Set<Coordinate> = [start]
        var coord = connections(from: start, in: tiles).first
        while let next = coord {
            visited.insert(next)
            coord = tiles[next]!.connections(from: next).filter { visited.contains($0) == false }.first
        }
        return visited
    }

    static func run(_ source: InputData) {
        let (tiles, start) = loadTiles(from: source.lines)
        let mainLoop = loopCoordinates(start: start, tiles: tiles)

        print("Part 1 (\(source)): \(mainLoop.count / 2)")
    }
}

// MARK: - Part 2

extension Dictionary where Key == Coordinate, Value == Tile {
    var xRange: ClosedRange<Int> { keys.map { $0.x }.range() }
    var yRange: ClosedRange<Int> { keys.map { $0.y }.range() }
}

extension Collection where Element: Comparable {
    func range() -> ClosedRange<Element> {
        precondition(count > 0)
        let sorted = self.sorted()
        return sorted.first! ... sorted.last!
    }
}

enum Part2 {
    static func replaceStartWithPipe(start: Coordinate, tiles: inout [Coordinate: Tile]) {
        let adjacent = Set(Part1.connections(from: start, in: tiles))
        if adjacent == Set([start.up, start.down]) {
            tiles[start] = .vertical
        } else if adjacent == Set([start.left, start.right]) {
            tiles[start] = .horizontal
        } else if adjacent == Set([start.up, start.right]) {
            tiles[start] = .northEastBend
        } else if adjacent == Set([start.up, start.left]) {
            tiles[start] = .northWestBend
        } else if adjacent == Set([start.down, start.right]) {
            tiles[start] = .southEastBend
        } else if adjacent == Set([start.down, start.left]) {
            tiles[start] = .southWestBend
        }
        assert(tiles[start] != .start)
    }

    static func findInteriorTiles(tiles: [Coordinate: Tile], loop: Set<Coordinate>) -> Set<Coordinate> {
        var result: Set<Coordinate> = []
        let yRange = tiles.yRange
        let xRange = tiles.xRange
        for y in yRange {
            var isInside = false
            var prevBend: Tile?
            for x in xRange {
                let c = Coordinate(x: x, y: y)
                if loop.contains(c) {
                    switch (tiles[c], prevBend) {
                    case (.southEastBend, _): prevBend = .southEastBend
                    case (.northEastBend, _): prevBend = .northEastBend
                    case (.vertical, _): isInside.toggle()
                    case (.southWestBend, .northEastBend): isInside.toggle()
                    case (.northWestBend, .southEastBend): isInside.toggle()
                    default: break
                    }
                } else if isInside {
                    result.insert(c)
                }
            }
        }
        return result
    }

    static func run(_ source: InputData) {
        var (tiles, start) = loadTiles(from: source.lines)
        let mainLoop = Part1.loopCoordinates(start: start, tiles: tiles)

        replaceStartWithPipe(start: start, tiles: &tiles)
        let inside = findInteriorTiles(tiles: tiles, loop: mainLoop)

        print("Part 2 (\(source)): \(inside.count)")
    }
}
