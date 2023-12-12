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
    static let initial = Self(conditionIdx: 0, groupIdx: 0, hashCount: 0)

    var conditionIdx: Int
    var groupIdx: Int
    var hashCount: Int

    func next(_ builder: (inout Self) -> Void = { _ in }) -> Self {
        var new = self
        builder(&new)
        new.conditionIdx = self.conditionIdx + 1
        return new
    }
}

enum Part1 {
    static func arrangements(_ record: Record) -> Int {
        var memo: [State: Int] = [:]
        let condition = record.condition
        let groups = record.groups

        func arrangements(_ state: State) -> Int {
            if let result = memo[state] {
                return result
            }
            if state.conditionIdx == condition.count {
                if state.groupIdx == groups.count && state.hashCount == 0 {
                    memo[state] = 1
                    return 1
                }
                if state.groupIdx == groups.count - 1 && state.hashCount == groups[state.groupIdx] {
                    memo[state] = 1
                    return 1
                }
                memo[state] = 0
                return 0
            }

            var result = 0
            let char = condition[state.conditionIdx]
            if char == "." || char == "?" {
                if state.hashCount == 0 {
                    result += arrangements(state.next())
                } else if state.groupIdx < groups.count && state.hashCount == groups[state.groupIdx] {
                    result += arrangements(state.next {
                        $0.groupIdx += 1
                        $0.hashCount = 0
                    })
                }
            }
            if char == "#" || char == "?" {
                result += arrangements(state.next { $0.hashCount += 1 })
            }

            memo[state] = result
            return result
        }

        return arrangements(.initial)
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
