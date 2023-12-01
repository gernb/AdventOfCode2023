//
//  Solution.swift
//  Day 01
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let values = input.map {
            let ints = $0.compactMap { Int(String($0)) }
            let value = String(ints.first!) + String(ints.last!)
            return Int(value)!
        }

        print(values)

        print("Part 1 (\(source)): \(values.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}
