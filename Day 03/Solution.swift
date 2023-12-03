//
//  Solution.swift
//  Day 03
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Coordinate: Hashable {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

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

func loadSchematic(from lines: [String]) -> [Coordinate: String] {
    var schematic: [Coordinate: String] = [:]
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            schematic[.init(x: x, y: y)] = String(char)
        }
    }
    return schematic
}

extension Dictionary where Key == Coordinate, Value == String {
    var xRange: ClosedRange<Int> { keys.map { $0.x }.range() }
    var yRange: ClosedRange<Int> { keys.map { $0.y }.range() }

    func adjacentIsSymbol(from coord: Coordinate) -> Bool {
        for neighbour in coord.adjacent {
            if let char = self[neighbour], char != ".", Int(char) == nil {
                return true
            }
        }
        return false
    }
}

extension Collection where Element: Comparable {
    func range() -> ClosedRange<Element> {
        precondition(count > 0)
        let sorted = self.sorted()
        return sorted.first! ... sorted.last!
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let schematic = loadSchematic(from: source.data)
        var partNumbers: [Int] = []
        var numberAccumulator = 0
        var isPartNumber = false
        for y in schematic.yRange {
            for x in schematic.xRange {
                let coord = Coordinate(x: x, y: y)
                let char = schematic[coord]!
                if let digit = Int(char) {
                    numberAccumulator = numberAccumulator * 10 + digit
                    isPartNumber = isPartNumber || schematic.adjacentIsSymbol(from: coord)
                } else {
                    if numberAccumulator > 0 && isPartNumber {
                        partNumbers.append(numberAccumulator)
                    }
                    numberAccumulator = 0
                    isPartNumber = false
                }
            }
            if numberAccumulator > 0 && isPartNumber {
                partNumbers.append(numberAccumulator)
            }
            numberAccumulator = 0
            isPartNumber = false
        }

        // ! 1837615
        print("Part 1 (\(source)): \(partNumbers.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}
