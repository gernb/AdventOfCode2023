//
//  Solution.swift
//  Day 15
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Part1 {
    static func hash(_ string: any StringProtocol) -> Int {
        string.reduce(into: 0) { result, char in
            result = ((result + Int(char.asciiValue!)) * 17) % 256
        }
    }

    static func run(_ source: InputData) {
        let instructions = source.lines.joined().split(separator: ",")
        let values = instructions.map(hash(_:))

        print("Part 1 (\(source)): \(values.reduce(0, +))")
    }
}

// MARK: - Part 2

enum Operation {
    case remove(String)
    case add(String, Int)

    var hash: Int {
        switch self {
        case .remove(let label): Part1.hash(label)
        case .add(let label, _): Part1.hash(label)
        }
    }
}
extension Operation {
    init(_ string: any StringProtocol) {
        if string.hasSuffix("-") {
            let label = String(string.dropLast())
            self = .remove(label)
        } else {
            let parts = string.split(separator: "=").map { String($0) }
            let label = parts[0]
            let focalLen = Int(parts[1])!
            self = .add(label, focalLen)
        }
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let operations = source.lines.joined().split(separator: ",").map(Operation.init)
        let boxes: [Int: [(label: String, focalLen: Int)]] = operations.reduce(into: [:]) { result, op in
            var list = result[op.hash, default: []]
            switch op {
            case .remove(let label):
                list.removeAll(where: { $0.label == label })
            case .add(let label, let focalLen):
                if let idx = list.firstIndex(where: { $0.label == label }) {
                    list[idx] = (label, focalLen)
                } else {
                    list.append((label, focalLen))
                }
            }
            result[op.hash] = list
        }
        let totalPower = boxes.reduce(0) { result, pair in
            let box = pair.key
            return result + pair.value.enumerated().reduce(0, { result, pair in
                result + (box + 1) * (pair.offset + 1) * pair.element.focalLen
            })
        }

        print("Part 2 (\(source)): \(totalPower)")
    }
}
