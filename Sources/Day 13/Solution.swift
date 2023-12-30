//
//  Solution.swift
//  Day 13
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Pattern {
    let rows: [String]

    func rotate() -> [String] {
        var result: [[Character]] = rows[0].map { [$0] }
        for line in rows.dropFirst() {
            line.enumerated().forEach { (idx: Int, char: Character) in
                result[idx].append(char)
            }
        }
        return result.map { String($0.reversed()) }
    }
}
extension Pattern {
    init(_ rows: ArraySlice<String>) {
        self.init(rows: Array(rows))
    }
}

enum Part1 {
    static func summarize(_ pattern: Pattern) -> Int {
        func findLine(_ rows: [String]) -> Int? {
            let count = rows.count
            var line = 0
            while line < count - 1 {
                line += 1
                let remaining = count - line
                let top: [String]
                let bottom: [String]
                if line < remaining {
                    top = Array(rows.prefix(line))
                    bottom = Array(rows.dropFirst(line).prefix(line).reversed())
                } else {
                    let size = line - remaining
                    top = Array(rows.dropFirst(size).prefix(remaining))
                    bottom = Array(rows.dropFirst(line).reversed())
                }
                if top == bottom {
                    return line
                }
            }
            return nil
        }

        if let row = findLine(pattern.rows) {
            return row * 100
        } else {
            let column = findLine(pattern.rotate())!
            return column
        }
    }

    static func run(_ source: InputData) {
        let patterns = source.lines.split(separator: "").map(Pattern.init)
        let scores = patterns.map(summarize(_:))

        print("Part 1 (\(source)): \(scores.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func diffCount<S1: Sequence, S2: Sequence>(_ top: S1, _ bottom: S2) -> Int where S1.Element == String, S2.Element == String {
        zip(top, bottom).reduce(0) { result, pair in
            result + zip(pair.0, pair.1).reduce(0) { result, pair in
                result + (pair.0 == pair.1 ? 0 : 1)
            }
        }
    }

    static func summarize(_ pattern: Pattern) -> Int {
        func findLine(_ rows: [String]) -> Int? {
            let count = rows.count
            var line = 0
            while line < count - 1 {
                line += 1
                let remaining = count - line
                let top: [String].SubSequence
                let bottom: ReversedCollection<[String].SubSequence>
                if line < remaining {
                    top = rows.prefix(line)
                    bottom = rows.dropFirst(line).prefix(line).reversed()
                } else {
                    top = rows.dropFirst(line - remaining).prefix(remaining)
                    bottom = rows.dropFirst(line).reversed()
                }
                if diffCount(top, bottom) == 1 {
                    return line
                }
            }
            return nil
        }

        if let row = findLine(pattern.rows) {
            return row * 100
        } else {
            let column = findLine(pattern.rotate())!
            return column
        }
    }

    static func run(_ source: InputData) {
        let patterns = source.lines.split(separator: "").map(Pattern.init)
        let scores = patterns.map(summarize(_:))

        print("Part 2 (\(source)): \(scores.reduce(0, +))")
    }
}
