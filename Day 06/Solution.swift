//
//  Solution.swift
//  Day 06
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Part1 {
    static func distances(for maxTime: Int) -> [Int] {
        (0 ... maxTime).map { holdTime in
            holdTime * (maxTime - holdTime)
        }
    }

    static func run(_ source: InputData) {
        let times = source.data[0].split(separator: " ").compactMap { Int(String($0)) }
        let maxDistances = source.data[1].split(separator: " ").compactMap { Int(String($0)) }
        let maxTime = times.max()!
        let winningSolutions = zip(times, maxDistances).map { (time: Int, distance: Int) in
            distances(for: time).filter { $0 > distance }.count
        }

        print("Part 1 (\(source)): \(winningSolutions.reduce(1, *))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}
