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
        let instructions = source.lines[0].map(String.init)
        let maps = loadMaps(source.lines.dropFirst(2))

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

func gcd(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

func lcm(_ m: Int, _ n: Int) -> Int {
    return (m * n) / gcd(m, n)
}

enum Part2 {
    static func countSteps(from start: String, instructions: [String], maps: [String: Map]) -> Int {
        let count = instructions.count
        var idx = 0
        var map = start
        var steps = 0
        while map.suffix(1) != "Z" {
            map = maps[map]!.next(instructions[idx])
            steps += 1
            idx = (idx + 1) % count
        }
        return steps
    }

    static func run(_ source: InputData) {
        let instructions = source.lines[0].map(String.init)
        let maps = Part1.loadMaps(source.lines.dropFirst(2))

        let locations = maps.keys.filter { $0.suffix(1) == "A" }
        let steps = locations.map { countSteps(from: $0, instructions: instructions, maps: maps) }
        let result = steps.reduce(1, lcm(_:_:))

        print("Part 2 (\(source)): \(result)")
    }
}
