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
    struct State {
        static let initial = Self(workflow: "in", x: 1 ... 4000, m: 1 ... 4000, a: 1 ... 4000, s: 1 ... 4000)

        var workflow: String
        var x: ClosedRange<Int>
        var m: ClosedRange<Int>
        var a: ClosedRange<Int>
        var s: ClosedRange<Int>

        var isDeadEnd: Bool {
            workflow == "R" || x.count == 0 || m.count == 0 || a.count == 0 || s.count == 0
        }

        mutating func apply(rule: Rule) -> State {
            switch rule {
            case let .always(destination):
                var next = self
                next.workflow = destination
                return next
            case let .lessThan(keyPath, value, destination):
                defer { self[keyPath: keyPath] = self[keyPath: keyPath].clamped(to: value ... 4000) }
                var next = self
                next.workflow = destination
                next[keyPath: keyPath] = next[keyPath: keyPath].clamped(to: 1 ... value - 1)
                return next
            case let.greaterThan(keyPath, value, destination):
                defer { self[keyPath: keyPath] = self[keyPath: keyPath].clamped(to: 1 ... value) }
                var next = self
                next.workflow = destination
                next[keyPath: keyPath] = next[keyPath: keyPath].clamped(to: value + 1 ... 4000)
                return next
            }
        }
    }

    enum Rule {
        case always(String)
        case lessThan(WritableKeyPath<State, ClosedRange<Int>>, Int, String)
        case greaterThan(WritableKeyPath<State, ClosedRange<Int>>, Int, String)
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
                    return .always(tokens[0])
                } else {
                    let destination = tokens[1]
                    var string = tokens[0]
                    let property =
                        switch string.removeFirst() {
                        case "x": \State.x
                        case "m": \State.m
                        case "a": \State.a
                        case "s": \State.s
                        default: fatalError()
                        }
                    let op = string.removeFirst()
                    let value = Int(string)!
                    return switch op {
                    case "<": .lessThan(property, value, destination)
                    case ">": .greaterThan(property, value, destination)
                    default: fatalError()
                    }
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

        func count(_ state: State) -> Int {
            if state.isDeadEnd {
                return 0
            }
            if state.workflow == "A" {
                return state.x.count * state.m.count * state.a.count * state.s.count
            }
            var state = state
            return workflows[state.workflow]!.rules.reduce(0) { result, rule in
                result + count(state.apply(rule: rule))
            }
        }

        let accepted = count(.initial)

        print("Part 2 (\(source)): \(accepted)")
    }
}
