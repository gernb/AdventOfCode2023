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

enum Operation: String {
    case dash = "-"
    case equals = "="
}

struct Instruction: Equatable {
    let label: String
    let focalLen: Int
    let operation: Operation

    var hash: Int { Part1.hash(label) }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.label == rhs.label
    }
}
extension Instruction {
    init(_ string: any StringProtocol) {
        if string.hasSuffix("-") {
            let label = String(string.dropLast())
            self.init(label: label, focalLen: 0, operation: .dash)
        } else {
            let parts = string.split(separator: "=").map { String($0) }
            let focalLen = Int(parts[1])!
            self.init(label: parts[0], focalLen: focalLen, operation: .equals)
        }
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let instructions = source.lines.joined().split(separator: ",").map(Instruction.init)
        let boxes: [Int: [Instruction]] = instructions.reduce(into: [:]) { result, instruction in
            var list = result[instruction.hash, default: []]
            switch instruction.operation {
            case .dash:
                list.removeAll(where: { $0 == instruction })
            case .equals:
                if let idx = list.firstIndex(of: instruction) {
                    list[idx] = instruction
                } else {
                    list.append(instruction)
                }
            }
            result[instruction.hash] = list
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
