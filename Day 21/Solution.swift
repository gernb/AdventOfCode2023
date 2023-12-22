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
    static func quadraticFitValue(for n: Int, using points: [(x: Int, y: Int)]) -> Int {
        func coefficients(for points: [(x: Int, y: Int)]) -> (a: Double, b: Double, c: Double) {
            guard points.count >= 3 else { fatalError() }
            let (x1, x2, x3) = (Double(points[points.count - 1].x), Double(points[points.count - 2].x), Double(points[points.count - 3].x))
            let (y1, y2, y3) = (Double(points[points.count - 1].y), Double(points[points.count - 2].y), Double(points[points.count - 3].y))
            guard x1 - x2 == x2 - x3 else { fatalError("Values must be equally spaced") }

            let a = (y1 - 2 * y2 + y3) / (x1 * x1 - 2 * x2 * x2 + x3 * x3)
            let b = (y1 - y2 - a * x1 * x1 + a * x2 * x2) / (x1 - x2)
            let c = y1 - a * x1 * x1 - b * x1
            return (a, b, c)
        }

        let (a, b, c) = coefficients(for: points)
        let x = Double(n)
        let y = a * x * x + b * x + c
        return Int(y.rounded())
    }

    static func run(_ source: InputData) {
        let (map, start) = loadGardenMap(source.lines)
        let size = source.lines.count
        assert(size == source.lines[0].count)

        var tiles: Set<Coordinate> = [start]
        var points: [(Int, Int)] = []
        var previousPrediction: Int?

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
                points.append((stepCount, tiles.count))
                if points.count >= 3 {
                    let prediction = quadraticFitValue(for: source.steps, using: points)
                    if prediction == previousPrediction {
                        break
                    }
                    previousPrediction = prediction
                }
            }
            tiles = next
        }

        print("Part 2 (\(source), steps: \(source.steps)): \(previousPrediction ?? tiles.count)")
    }
}
