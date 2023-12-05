//
//  Solution.swift
//  Day 05
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Category: String {
    case seed, soil, fertilizer, water, light, temperature, humidity, location
}

struct Almanac {
    struct Map {
        let source: Category
        let destination: Category
        let sourceRanges: [ClosedRange<Int>]
        let destinationRanges: [Int]

        let lowerBound: Int
        let upperBound: Int

        func output(for input: Int) -> Int {
            guard input >= lowerBound && input <= upperBound else {
                return input
            }
            for (idx, range) in sourceRanges.enumerated() {
//                if range.contains(input) {
                if input >= range.lowerBound && input <= range.upperBound {
                    return input - range.lowerBound + destinationRanges[idx]
                }
            }
            return input
        }
    }

    let maps: [Category: Map]

    func location(for seed: Int) -> Int {
        var source = Category.seed
        var number = seed
        while source != .location {
            let map = maps[source]!
            number = map.output(for: number)
            source = map.destination
        }
        return number
    }
}
extension Almanac.Map {
    init(_ lines: ArraySlice<String>) {
        let parts = lines.first!.split(separator: " ")[0].split(separator: "-")
        let source = String(parts[0])
        let destination = String(parts[2])
        let ranges = lines.dropFirst().map { line in
            let values = line.split(separator: " ").map { Int(String($0))! }
            return (values[1] ... values[1] + values[2] - 1, values[0])
        }
        self.init(
            source: Category(rawValue: source)!,
            destination: Category(rawValue: destination)!,
            sourceRanges: ranges.map(\.0),
            destinationRanges: ranges.map(\.1),
            lowerBound: ranges.map(\.0.lowerBound).min()!,
            upperBound: ranges.map(\.0.upperBound).max()!
        )
    }
}
extension Almanac {
    init(_ input: ArraySlice<ArraySlice<String>>) {
        self.maps = input.reduce(into: [:]) { result, lines in
            let map = Almanac.Map(lines)
            result[map.source] = map
        }
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.split(separator: "")
        let seeds = input.first!.first!.split(separator: " ").compactMap { Int(String($0)) }
        let almanac = Almanac(input.dropFirst())
        let locations = seeds.map { almanac.location(for: $0) }

        print("Part 1 (\(source)): \(locations.min()!)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data.split(separator: "")
        let seedPairs = input.first!.first!.split(separator: " ").compactMap { Int(String($0)) }
        let almanac = Almanac(input.dropFirst())
        var minLocation = Int.max
        for idx in stride(from: 0, to: seedPairs.count - 1, by: 2) {
            let seedStart = seedPairs[idx]
            let count = seedPairs[idx + 1]
            for seed in seedStart ..< seedStart + count {
                minLocation = min(minLocation, almanac.location(for: seed))
            }
            print(".", terminator: "")
        }

        print("\nPart 2 (\(source)): \(minLocation)")
    }
}
