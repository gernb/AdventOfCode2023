//
//  Solution.swift
//  Day 15
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Part1 {
    static func hash(_ string: any StringProtocol) -> Int {
        string.reduce(into: 0) { result, char in
            result = ((result + Int(char.asciiValue!)) * 17) % 256
        }
    }

    static func run(_ source: InputData) {
        let instructions = source.lines.joined().split(separator: ",")
        let values = instructions.map(hash(_:))

        print("Part 1 (\(source)): \(values.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
