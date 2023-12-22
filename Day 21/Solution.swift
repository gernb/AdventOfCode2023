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
        print("Part 1 (\(source), steps: \(source.steps)): \(tiles.count)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func fitQuadratic(x: [Int], y: [Int]) -> (a: Double, b: Double, c: Double) {
        guard x.count >= 3 && x.count == y.count else { fatalError() }
        let (x1, x2, x3) = (Double(x[x.count - 1]), Double(x[x.count - 2]), Double(x[x.count - 3]))
        let (y1, y2, y3) = (Double(y[y.count - 1]), Double(y[y.count - 2]), Double(y[y.count - 3]))
        guard x1 - x2 == x2 - x3 else { fatalError("Values must be equally spaced") }

        let a = (y1 - 2 * y2 + y3) / (x1 * x1 - 2 * x2 * x2 + x3 * x3)
        let b = (y1 - y2 - a * x1 * x1 + a * x2 * x2) / (x1 - x2)
        let c = y1 - a * x1 * x1 - b * x1
        return (a, b, c)
    }

    static func run(_ source: InputData) {
        let (map, start) = loadGardenMap(source.lines)
        let size = source.lines.count
        assert(size == source.lines[0].count)

        var tiles: Set<Coordinate> = [start]
        var x: [Int] = []
        var y: [Int] = []
        // Fewer than 7 values results in a bad quadratic fit for the examples
        let valueCount = source.name == "challenge" ? 3 : 7

        for stepCount in 0 ..< source.steps {
            var next: Set<Coordinate> = []
            for coord in tiles {
                next.formUnion(
                    coord.neighbours.filter {
                        var x = $0.x % size
                        if x < 0 {
                            x = size + x
                        }
                        var y = $0.y % size
                        if y < 0 {
                            y = size + y
                        }
                        let c = Coordinate(x: x, y: y)
                        return map[c] == .garden
                    }
                )
            }

            if (stepCount % size) == (source.steps % size) {
                x.append(stepCount)
                y.append(tiles.count)
                if x.count == valueCount {
                    break
                }
            }
            tiles = next
        }
        if x.count == valueCount {
            let (a, b, c) = fitQuadratic(x: x, y: y)
            let n = Double(source.steps)
            let value = a * n * n + b * n + c
            print("Part 2 (\(source), steps: \(source.steps)): \(Int(value.rounded()))")
        } else {
            print("Part 2 (\(source), steps: \(source.steps)): \(tiles.count)")
        }
    }
}
