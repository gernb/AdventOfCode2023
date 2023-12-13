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
    static func diffCount(_ top: [String], _ bottom: [String]) -> Int {
        zip(top, bottom).reduce(0) { result, pair in
            result + zip(pair.0, pair.1).reduce(0) { result, pair in
                result + (pair.0 == pair.1 ? 0 : 1)
            }
        }
    }

    static func summarize(_ pattern: Pattern, skipping value: Int) -> Int {
        func findLine(_ rows: [String], skipping row: Int?) -> Int? {
            let count = rows.count
            var line = 0
            while line < count - 1 {
                line += 1
                if line == row { continue }
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
                if diffCount(top, bottom) == 1 {
                    return line
                }
            }
            return nil
        }

        if let row = findLine(pattern.rows, skipping: value > 100 ? value / 100 : nil) {
            return row * 100
        } else {
            let column = findLine(pattern.rotate(), skipping: value < 100 ? value : nil)!
            return column
        }
    }

    static func run(_ source: InputData) {
        let patterns = source.lines.split(separator: "").map(Pattern.init)
        let original = patterns.map(Part1.summarize(_:))
        let scores = zip(patterns, original).map { (pattern: Pattern, value: Int) in
            summarize(pattern, skipping: value)
        }

        print("Part 2 (\(source)): \(scores.reduce(0, +))")
    }
}
