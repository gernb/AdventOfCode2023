//
//  Solution.swift
//  Day 12
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Record {
    let condition: [Character]
    let groups: [Int]
}
extension Record {
    init(_ line: String) {
        let parts = line.split(separator: " ").map(String.init)
        let condition = Array(parts[0])
        let groups = parts[1].split(separator: ",").map { Int(String($0))! }
        self.init(condition: condition, groups: groups)
    }
}

struct State: Hashable {
    var conditionIdx: Int
    var groupIdx: Int
    var groupCount: Int
}

enum Part1 {
    static func arrangements(_ record: Record) -> Int {
        var memo: [State: Int] = [:]

        func arrangements(_ record: Record, _ state: State) -> Int {
            if let result = memo[state] {
                return result
            }
            if state.conditionIdx == record.condition.count {
                if state.groupIdx == record.groups.count && state.groupCount == 0 {
                    memo[state] = 1
                    return 1
                }
                if state.groupIdx == record.groups.count - 1 && state.groupCount == record.groups[state.groupIdx] {
                    memo[state] = 1
                    return 1
                }
                memo[state] = 0
                return 0
            }

            var result = 0
            if record.condition[state.conditionIdx] == "." || record.condition[state.conditionIdx] == "?" {
                if state.groupCount == 0 {
                    let new = State(conditionIdx: state.conditionIdx + 1, groupIdx: state.groupIdx, groupCount: 0)
                    result += arrangements(record, new)
                } else if state.groupCount > 0 && state.groupIdx < record.groups.count && state.groupCount == record.groups[state.groupIdx] {
                    let new = State(conditionIdx: state.conditionIdx + 1, groupIdx: state.groupIdx + 1, groupCount: 0)
                    result += arrangements(record, new)
                }
            }
            if record.condition[state.conditionIdx] == "#" || record.condition[state.conditionIdx] == "?" {
                let new = State(conditionIdx: state.conditionIdx + 1, groupIdx: state.groupIdx, groupCount: state.groupCount + 1)
                result += arrangements(record, new)
            }

            memo[state] = result
            return result
        }

        return arrangements(record, State(conditionIdx: 0, groupIdx: 0, groupCount: 0))
    }

    static func run(_ source: InputData) {
        let records = source.lines.map(Record.init)
        let counts = records.map(arrangements)

        print("Part 1 (\(source)): \(counts.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func unfold(_ record: Record) -> Record {
        let condition = Array(repeating: record.condition, count: 5).joined(separator: "?")
        let groups = Array(repeating: record.groups, count: 5).flatMap { $0 }
        return .init(condition: Array(condition), groups: groups)
    }

    static func run(_ source: InputData) {
        let records = source.lines.map(Record.init).map(unfold)
        let counts = records.map(Part1.arrangements)

        print("Part 2 (\(source)): \(counts.reduce(0, +))")
    }
}
