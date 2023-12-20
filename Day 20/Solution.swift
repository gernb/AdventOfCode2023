//
//  Solution.swift
//  Day 20
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Module: Equatable {
    case flipFlop(destinations: [String], isOn: Bool)
    case conjunction(destinations: [String], source: [String: Int])
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
            result[name] = .conjunction(destinations: destinations, source: [:])
        default:
            assert(parts[0] == "broadcaster")
            result["broadcaster"] = .broadcast(destinations: destinations)
        }
    }
    for (name, module) in result {
        for destination in module.destinations {
            if case .conjunction(let destinations, var source) = result[destination] {
                source[name] = 0
                result[destination] = .conjunction(destinations: destinations, source: source)
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
    static func pushButton(modules: inout [String: Module], onSignal handler: (Signal) -> Void) {
        var queue: [Signal] = [.button]
        while queue.isEmpty == false {
            let signal = queue.removeFirst()
            handler(signal)
            let name = signal.destination
            switch modules[name] {
            case .broadcast(let destinations):
                queue.append(contentsOf: destinations.map { Signal(source: name, destination: $0, pulse: signal.pulse) })
            case .flipFlop(let destinations, var isOn):
                guard signal.pulse == 0 else { continue }
                queue.append(contentsOf: destinations.map { Signal(source: name, destination: $0, pulse: isOn ? 0 : 1) })
                isOn.toggle()
                modules[name] = .flipFlop(destinations: destinations, isOn: isOn)
            case .conjunction(let destinations, var source):
                source[signal.source] = signal.pulse
                let pulse = source.values.allSatisfy({ $0 == 1 }) ? 0 : 1
                queue.append(contentsOf: destinations.map { Signal(source: name, destination: $0, pulse: pulse) })
                modules[name] = .conjunction(destinations: destinations, source: source)
            case .none:
                break
            }
        }
    }

    static func run(_ source: InputData) {
        var modules = loadModules(source.lines)
        var counts = [0, 0]
        for _ in 1 ... 1000 {
            pushButton(modules: &modules) { signal in
                counts[signal.pulse] += 1
            }
        }

        print("Part 1 (\(source)): \(counts[0] * counts[1])")
    }
}

// MARK: - Part 2

func gcd(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

func lcm(_ m: Int, _ n: Int) -> Int {
    return (m * n) / gcd(m, n)
}

enum Part2 {
    static func run(_ source: InputData) {
        var modules = loadModules(source.lines)
        let (sourceName, sourceModule) = modules.filter { $0.value.destinations.contains("rx") }.first!
        guard case .conjunction(_, var counts) = sourceModule else { fatalError() }
        var buttonPressCount = 0
        repeat {
            buttonPressCount += 1
            Part1.pushButton(modules: &modules) { signal in
                if signal.pulse == 1 && signal.destination == sourceName {
                    if counts[signal.source]! == 0 {
                        counts[signal.source] = buttonPressCount
                    }
                }
            }
        } while counts.values.allSatisfy({ $0 != 0 }) == false
        let result = counts.values.reduce(1, lcm)

        print("Part 2 (\(source)): \(result)")
    }
}
