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
        let input = source.data
        let values = input.map {
            let ints = $0.compactMap { Int(String($0)) }
            let value = String(ints.first!) + String(ints.last!)
            return Int(value)!
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
        var matches: [(idx: Int, value: Int)] = []
        for (n, word) in digitWords.enumerated() {
            for range in string.ranges(of: word) {
                let idx = string.distance(from: string.startIndex, to: range.lowerBound)
                matches.append((idx, n + 1))
            }
        }
        return matches.sorted(by: { $0.idx < $1.idx })
    }

    static func run(_ source: InputData) {
        if source == .example { return }
        let input = source.data
        let values = input.map {
            let ints = $0.map { Int(String($0)) }
            let words = wordIndicies(in: $0)

            let firstDigitIdx = ints.firstIndex(where: { $0 != nil }) ?? Int.max
            let firstWordIdx = words.first ?? (idx: Int.max, value: 0)
            let firstDigit = (firstDigitIdx < firstWordIdx.idx) ? ints[firstDigitIdx]! : firstWordIdx.value

            let lastDigitIdx = ints.lastIndex(where: { $0 != nil }) ?? Int.min
            let lastWordIdx = words.last ?? (idx: Int.min, value: 0)
            let lastDigit = (lastDigitIdx > lastWordIdx.idx) ? ints[lastDigitIdx]! : lastWordIdx.value

            let value = String(firstDigit) + String(lastDigit)
            return Int(value)!
        }

        print("Part 2 (\(source)): \(values.reduce(0, +))")
    }
}
