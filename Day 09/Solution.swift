//
//  Solution.swift
//  Day 09
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Part1 {
    static func nextValue(for history: [Int]) -> Int {
        var sequences = [history]
        while sequences.last!.allSatisfy({ $0 == 0 }) == false {
            let sequence = sequences.last!
            let newSequence = sequence
                .enumerated()
                .dropLast()
                .map { (idx: Int, value: Int) in
                    sequence[idx + 1] - value
                }
            sequences.append(newSequence)
        }
        var nextValue = 0
        for sequence in sequences.dropLast().reversed() {
            nextValue += sequence.last!
        }
        return nextValue
    }

    static func run(_ source: InputData) {
        var historyLines = source.data.map { line in
            line.split(separator: " ").map { Int(String($0))! }
        }
        for idx in 0 ..< historyLines.count {
            historyLines[idx].append(nextValue(for: historyLines[idx]))
        }

        let sum = historyLines.map { $0.last! }.reduce(0, +)
        print("Part 1 (\(source)): \(sum)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}
