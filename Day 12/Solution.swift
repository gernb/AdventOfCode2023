//
//  Solution.swift
//  Day 12
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

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
    static func arrangements(_ condition: String, _ groups: [Int]) -> Int {
        var condition = condition.trimmingCharacters(in: ["."])
        if condition.count < (groups.reduce(0, +) + groups.count - 1) {
            return 0
        }
        if groups.isEmpty && condition.isEmpty {
            return 1
        }
        if groups.isEmpty && condition.allSatisfy({ $0 == "." || $0 == "?" }) {
            return 1
        }
        if groups.isEmpty || condition.isEmpty {
            return 0
        }

        var groups = groups
        var result = 0
        let char = condition.removeFirst()
        if char == "?" {
            result += arrangements(condition, groups)
        }
        let hashNeeded = groups.removeFirst()
        var hashCount = 1
        while true {
            while condition.isEmpty == false, condition.first == "#" {
                condition.removeFirst()
                hashCount += 1
            }
            if hashCount > hashNeeded {
                return result
            }
            if hashCount == hashNeeded {
                if condition.isEmpty {
                    return result + arrangements(condition, groups)
                }
                condition.removeFirst()
                return result + arrangements(condition, groups)
            }
            if condition.first == "." {
                return result
            }
            if condition.isEmpty {
                return result
            }
            condition.removeFirst()
            hashCount += 1
        }
        return result
    }

    static func run(_ source: InputData) {
        let records = source.lines.map(Record.init)
        let counts = records.map { record in
            arrangements(record.condition, record.groups)
        }

        print("Part 1 (\(source)): \(counts.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func unfold(_ record: Record) -> Record {
        let condition = Array(repeating: record.condition, count: 5).joined(separator: "?")
        let groups = Array(repeating: record.groups, count: 5).flatMap { $0 }
        return .init(condition: condition, groups: groups)
    }

    static func run(_ source: InputData) {
        let records = source.lines.map(Record.init).map(unfold)

        let counts = records.enumerated().map { (n: Int, record: Record) in
//            print(n)
            return Part1.arrangements(record.condition, record.groups)
        }

        print("Part 2 (\(source)): \(counts.reduce(0, +))")
    }
}
