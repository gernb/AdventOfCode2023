//
//  Solution.swift
//  Day 01
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Part1 {
    static func run(_ source: InputData) {
        if source == .example2 { return }
        let values = source.data.map {
            let ints = $0.compactMap { Int(String($0)) }
            return ints.first! * 10 + ints.last!
        }

        print("Part 1 (\(source)): \(values.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static let digitWords = [
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
    ]

    static func wordIndicies(in string: String) -> [(idx: Int, value: Int)] {
        digitWords.enumerated()
            .reduce(into: [(Int, Int)]()) { result, pair in
                for range in string.ranges(of: pair.element) {
                    let idx = string.distance(from: string.startIndex, to: range.lowerBound)
                    result.append((idx, pair.offset + 1))
                }
            }
    }

    static func run(_ source: InputData) {
        if source == .example { return }
        let values = source.data.map {
            var numbers: [(idx: Int, value: Int)] = $0.enumerated().compactMap { pair in
                Int(String(pair.element)).map { (pair.offset, $0) }
            }
            numbers.append(contentsOf: wordIndicies(in: $0))
            numbers.sort(by: { $0.idx < $1.idx })
            return numbers.first!.value * 10 + numbers.last!.value
        }

        print("Part 2 (\(source)): \(values.reduce(0, +))")
    }
}
