//
//  Solution.swift
//  Day 11
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

    var adjacent: [Self] { [up, left, right, down] }

    func distance(to other: Self) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
}

extension Collection {
    func combinations(of size: Int) -> [[Element]] {
        func pick(_ count: Int, from: ArraySlice<Element>) -> [[Element]] {
            guard count > 0 else { return [] }
            guard count < from.count else { return [Array(from)] }
            if count == 1 {
                return from.map { [$0] }
            } else {
                return from.dropLast(count - 1)
                    .enumerated()
                    .flatMap { pair in
                        return pick(count - 1, from: from.dropFirst(pair.offset + 1)).map { [pair.element] + $0 }
                    }
            }
        }

        return pick(size, from: ArraySlice(self))
    }
}

enum Part1 {
    static func expandGalaxies(_ image: [[Character]], rotateAndExpand: Bool = true) -> [[Character]] {
        var result: [[Character]] = image[0].map { [$0] }
        for line in image.dropFirst() {
            let isEmpty = line.allSatisfy({ $0 == "." })
            line.enumerated().forEach { (idx: Int, char: Character) in
                if isEmpty {
                    result[idx].append(contentsOf: [char, char])
                } else {
                    result[idx].append(char)
                }
            }
        }
        return rotateAndExpand ? expandGalaxies(result, rotateAndExpand: false) : result
    }

    static func galaxyLocations(in image: [[Character]]) -> [Coordinate] {
        image.enumerated().reduce(into: []) { result, pair in
            let y = pair.offset
            return result.append(contentsOf: pair.element.enumerated().compactMap({
                $0.element == "#" ? Coordinate(x: $0.offset, y: y) : nil
            }))
        }
    }

    static func run(_ source: InputData) {
        let image = source.lines.map(Array.init)
        let expanded = expandGalaxies(image)
        let galaxyPairs = galaxyLocations(in: expanded).combinations(of: 2)
        let distances = galaxyPairs.map { $0[0].distance(to: $0[1]) }

        print("Part 1 (\(source)): \(distances.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
