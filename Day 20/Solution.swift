//
//  Solution.swift
//  Day 20
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Module: Equatable {
    case flipFlop(destinations: [String], isOn: Bool)
    case conjunction(destinations: [String], received: [String: Int])
    case broadcast(destinations: [String])

    var destinations: [String] {
        switch self {
        case .flipFlop(let d, _): d
        case .conjunction(let d, _): d
        case .broadcast(let d): d
        }
    }
}

func loadModules(_ lines: [String]) -> [String: Module] {
    var result: [String: Module] = lines.reduce(into: [:]) { result, line in
        let parts = line.split(separator: " -> ")
        let destinations = parts[1].components(separatedBy: ", ")
        switch parts[0].first {
        case "%":
            let name = String(parts[0].dropFirst())
            result[name] = .flipFlop(destinations: destinations, isOn: false)
        case "&":
            let name = String(parts[0].dropFirst())
            result[name] = .conjunction(destinations: destinations, received: [:])
        default:
            assert(parts[0] == "broadcaster")
            result["broadcaster"] = .broadcast(destinations: destinations)
        }
    }
    for (name, module) in result {
        for destination in module.destinations {
            if case .conjunction(let destinations, var received) = result[destination] {
                received[name] = 0
                result[destination] = .conjunction(destinations: destinations, received: received)
            }
        }
    }
    return result
}

struct Signal {
    static let button = Self(source: "button", destination: "broadcaster", pulse: 0)

    let source: String
    let destination: String
    let pulse: Int
}

enum Part1 {
    static func pushButton(modules: inout [String: Module]) -> (lowCount: Int, highCount: Int) {
        var lowCount = 0
        var highCount = 0
        var queue: [Signal] = [.button]
        while queue.isEmpty == false {
            let signal = queue.removeFirst()
            lowCount += signal.pulse == 0 ? 1 : 0
            highCount += signal.pulse == 1 ? 1 : 0
            let name = signal.destination
            switch modules[name] {
            case .broadcast(let destinations):
                queue.append(contentsOf: destinations.map { Signal(source: name, destination: $0, pulse: signal.pulse) })
            case .flipFlop(let destinations, var isOn):
                guard signal.pulse == 0 else { continue }
                queue.append(contentsOf: destinations.map { Signal(source: name, destination: $0, pulse: isOn ? 0 : 1) })
                isOn.toggle()
                modules[name] = .flipFlop(destinations: destinations, isOn: isOn)
            case .conjunction(let destinations, var received):
                received[signal.source] = signal.pulse
                let pulse = received.values.allSatisfy({ $0 == 1 }) ? 0 : 1
                queue.append(contentsOf: destinations.map { Signal(source: name, destination: $0, pulse: pulse) })
                modules[name] = .conjunction(destinations: destinations, received: received)
            case .none:
                break
            }
        }
        return (lowCount, highCount)
    }

    static func run(_ source: InputData) {
        let modules = loadModules(source.lines)
        var state = modules
        var lowCount = 0
        var highCount = 0
        for _ in 1 ... 1000 {
            let (low, high) = pushButton(modules: &state)
            lowCount += low
            highCount += high
        }

        print("Part 1 (\(source)): \(lowCount * highCount)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
