//
//  Solution.swift
//  Day 19
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Workflow {
    let name: String
    let rules: [(Part) -> String?]

    func run(with part: Part) -> String {
        for rule in rules {
            if let destination = rule(part) {
                return destination
            }
        }
        fatalError()
    }
}
extension Workflow {
    init(_ string: any StringProtocol) {
        var tokens = string.dropLast().split(separator: "{")
        let name = String(tokens[0])
        tokens = tokens[1].split(separator: ",")
        let rules: [(Part) -> String?] = tokens.map { token in
            let tokens = token.split(separator: ":")
            if tokens.count == 1 {
                let destination = String(tokens[0])
                return { _ in destination }
            } else {
                let destination = String(tokens[1])
                var rule = String(tokens[0])
                let keyPath =
                    switch rule.removeFirst() {
                    case "x": \Part.x
                    case "m": \Part.m
                    case "a": \Part.a
                    case "s": \Part.s
                    default: fatalError()
                    }
                let op = rule.removeFirst()
                let value = Int(rule)!
                return switch op {
                case "<": { $0[keyPath: keyPath] < value ? destination : nil }
                case ">": { $0[keyPath: keyPath] > value ? destination : nil }
                default: fatalError()
                }
            }
        }
        self.init(name: name, rules: rules)
    }
}

struct Part {
    let x: Int
    let m: Int
    let a: Int
    let s: Int

    var rating: Int { x + m + a + s }
}
extension Part {
    init(_ string: any StringProtocol) {
        let tokens = string.dropFirst().dropLast().components(separatedBy: ",")
        let values = tokens.map { Int(String($0.dropFirst(2)))! }
        self.init(x: values[0], m: values[1], a: values[2], s: values[3])
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let sections = source.lines.split(separator: "")
        let workflows: [String: Workflow] = sections[0].reduce(into: [:]) { result, line in
            let workflow = Workflow(line)
            result[workflow.name] = workflow
        }
        var accepted: [Part] = []
        var rejected: [Part] = []
        sections[1].map(Part.init).forEach { part in
            var destination = "in"
            while let workflow = workflows[destination] {
                destination = workflow.run(with: part)
            }
            switch destination {
            case "A": accepted.append(part)
            case "R": rejected.append(part)
            default: fatalError()
            }
        }
        let sum = accepted.reduce(0, { $0 + $1.rating })

        print("Part 1 (\(source)): \(sum)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
