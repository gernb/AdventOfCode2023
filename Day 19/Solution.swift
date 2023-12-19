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
    enum Operation {
        case lessThan, greaterThan, always
    }

    struct Rule: CustomStringConvertible {
        let property: String
        let op: Operation
        let value: Int
        let destination: String

        var description: String {
            switch op {
            case .always: "\(destination)"
            case .lessThan: "\(property)<\(value):\(destination)"
            case .greaterThan: "\(property)>\(value):\(destination)"
            }
        }
    }

    struct Workflow {
        let name: String
        let rules: [Rule]

        init(_ string: any StringProtocol) {
            var tokens = string.dropLast().split(separator: "{")
            let name = String(tokens[0])
            tokens = tokens[1].split(separator: ",")
            let rules: [Rule] = tokens.map { token in
                let tokens = token.components(separatedBy: ":")
                if tokens.count == 1 {
                    return .init(property: "", op: .always, value: 0, destination: tokens[0])
                } else {
                    let destination = tokens[1]
                    var string = tokens[0]
                    let property = String(string.removeFirst())
                    let op: Operation = switch string.removeFirst() {
                    case "<": .lessThan
                    case ">": .greaterThan
                    default: fatalError()
                    }
                    let value = Int(string)!
                    return .init(property: property, op: op, value: value, destination: destination)
                }
            }
            self.name = name
            self.rules = rules
        }
    }

    static func run(_ source: InputData) {
        let sections = source.lines.split(separator: "")
        let workflows: [String: Workflow] = sections[0].reduce(into: [:]) { result, line in
            let workflow = Workflow(line)
            result[workflow.name] = workflow
        }

        func count(for destination: String, x: ClosedRange<Int>, m: ClosedRange<Int>, a: ClosedRange<Int>, s: ClosedRange<Int>) -> Int {
            if destination == "R" {
                return 0
            } else if destination == "A" {
                return x.count * m.count * a.count * s.count
            }
            let workflow = workflows[destination]!
            var x = x
            var m = m
            var a = a
            var s = s
            var result = 0
            for rule in workflow.rules {
                switch (rule.op, rule.property) {
                case (.always, _):
                    result += count(for: rule.destination, x: x, m: m, a: a, s: s)

                case (.lessThan, "x"):
                    result += count(for: rule.destination, x: x.clamped(to: 1 ... rule.value - 1), m: m, a: a, s: s)
                    x = x.clamped(to: rule.value ... 4000)
                case (.lessThan, "m"):
                    result += count(for: rule.destination, x: x, m: m.clamped(to: 1 ... rule.value - 1), a: a, s: s)
                    m = m.clamped(to: rule.value ... 4000)
                case (.lessThan, "a"):
                    result += count(for: rule.destination, x: x, m: m, a: a.clamped(to: 1 ... rule.value - 1), s: s)
                    a = a.clamped(to: rule.value ... 4000)
                case (.lessThan, "s"):
                    result += count(for: rule.destination, x: x, m: m, a: a, s: s.clamped(to: 1 ... rule.value - 1))
                    s = s.clamped(to: rule.value ... 4000)

                case (.greaterThan, "x"):
                    result += count(for: rule.destination, x: x.clamped(to: rule.value + 1 ... 4000), m: m, a: a, s: s)
                    x = x.clamped(to: 1 ... rule.value)
                case (.greaterThan, "m"):
                    result += count(for: rule.destination, x: x, m: m.clamped(to: rule.value + 1 ... 4000), a: a, s: s)
                    m = m.clamped(to: 1 ... rule.value)
                case (.greaterThan, "a"):
                    result += count(for: rule.destination, x: x, m: m, a: a.clamped(to: rule.value + 1 ... 4000), s: s)
                    a = a.clamped(to: 1 ... rule.value)
                case (.greaterThan, "s"):
                    result += count(for: rule.destination, x: x, m: m, a: a, s: s.clamped(to: rule.value + 1 ... 4000))
                    s = s.clamped(to: 1 ... rule.value)

                default:
                    fatalError()
                }
            }
            return result
        }

        let accepted = count(for: "in", x: 1 ... 4000, m: 1 ... 4000, a: 1 ... 4000, s: 1 ... 4000)

        print("Part 2 (\(source)): \(accepted)")
    }
}
