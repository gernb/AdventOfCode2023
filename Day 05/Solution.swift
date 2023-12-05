//
//  Solution.swift
//  Day 05
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Almanac {
    struct Map {
        let source: String
        let destination: String
        let sourceRanges: [ClosedRange<Int>]
        let destinationRanges: [Int]

        func output(for input: Int) -> Int {
            for (idx, range) in sourceRanges.enumerated() {
                if range.contains(input) {
                    return input - range.lowerBound + destinationRanges[idx]
                }
            }
            return input
        }
    }

    let maps: [String: Map]

    func location(for seed: Int) -> Int {
        var source = "seed"
        var number = seed
        while source != "location" {
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
        self.init(source: source, destination: destination, sourceRanges: ranges.map(\.0), destinationRanges: ranges.map(\.1))
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
        let input = source.data

        print("Part 2 (\(source)):")
    }
}
