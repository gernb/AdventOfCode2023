//
//  Solution.swift
//  Day 08
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Map {
    let left: String
    let right: String

    func next(_ instruction: String) -> String {
        if instruction == "L" {
            return left
        } else {
            assert(instruction == "R")
            return right
        }
    }
}
extension Map {
    init(pair: String) {
        let values = pair.split(separator: ", ")
        let left = String(values[0].dropFirst())
        let right = String(values[1].dropLast())
        self.init(left: left, right: right)
    }
}

enum Part1 {
    static func loadMaps(_ lines: ArraySlice<String>) -> [String: Map] {
        lines.reduce(into: [:]) { result, line in
            let parts = line.split(separator: " = ")
            result[String(parts[0])] = Map(pair: String(parts[1]))
        }
    }
    static func run(_ source: InputData) {
        let lines = source.data
        let instructions = lines[0].map(String.init)
        let maps = loadMaps(lines.dropFirst(2))

        let count = instructions.count
        var idx = 0
        var map = "AAA"
        var steps = 0
        while map != "ZZZ" {
            map = maps[map]!.next(instructions[idx])
            steps += 1
            idx = (idx + 1) % count
        }

        print("Part 1 (\(source)): \(steps)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}
