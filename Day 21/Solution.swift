//
//  Solution.swift
//  Day 21
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

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

enum Tile {
    case garden, rock
}

func loadGardenMap(_ lines: [String]) -> (map: [Coordinate: Tile], start: Coordinate) {
    var start: Coordinate = Coordinate(x: 0, y: 0)
    return (
        lines.enumerated().reduce(into: [:]) { result, pair in
            let y = pair.offset
            result = pair.element.enumerated().reduce(into: result) { result, pair in
                let x = pair.offset
                let c = Coordinate(x: x, y: y)
                switch pair.element {
                case ".": result[c] = .garden
                case "#": result[c] = .rock
                case "S":
                    start = c
                    result[c] = .garden
                default:
                    fatalError()
                }
            }
        },
        start
    )
}

enum Part1 {
    static func run(_ source: InputData) {
        let (map, start) = loadGardenMap(source.lines)
        var tiles: Set<Coordinate> = [start]
        for _ in 1 ... source.steps {
            var next: Set<Coordinate> = []
            for coord in tiles {
                next.formUnion(coord.neighbours.filter({ map[$0] == .garden }))
            }
            tiles = next
        }
        print("Part 1 (\(source)): \(tiles.count)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
