//
//  Solution.swift
//  Day 12
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

//???.### 1,1,3
struct Record {
    let condition: String
    let groups: [Int]

    func matches(_ condition: String) -> Bool {
        condition.split(separator: ".").map(\.count) == groups
    }
}
extension Record {
    init(_ line: String) {
        let parts = line.split(separator: " ").map(String.init)
        let condition = parts[0]
        let groups = parts[1].split(separator: ",").map { Int(String($0))! }
        self.init(condition: condition, groups: groups)
    }
}

enum Part1 {
    static func arrangements(for record: Record) -> [String] {
        var result: [String] = [record.condition]
        while result[0].contains("?") {
            let condition = result.removeFirst()
            result.append(condition.replacing("?", with: ".", maxReplacements: 1))
            result.append(condition.replacing("?", with: "#", maxReplacements: 1))
        }

        return result
    }

    static func run(_ source: InputData) {
        let records = source.lines.map(Record.init)
        let counts = records.enumerated().map { (idx: Int, record: Record) in
            print(idx)
            return arrangements(for: record).filter(record.matches(_:)).count
        }

        print("Part 1 (\(source)): \(counts.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
