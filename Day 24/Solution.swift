//
//  Solution.swift
//  Day 24
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Vector3: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    var z: Int

    var description: String { "(\(x), \(y), \(z))" }

    static func + (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}
extension Vector3 {
    init(_ line: any StringProtocol) {
        let parts = line.components(separatedBy: ", ").map { Int($0.trimmingCharacters(in: .whitespaces))! }
        self.init(x: parts[0], y: parts[1], z: parts[2])
    }
}

struct Hailstone {
    var position: Vector3
    var velocity: Vector3
}
extension Hailstone {
    init(_ line: String) {
        let parts = line.split(separator: " @ ").map(Vector3.init)
        self.init(position: parts[0], velocity: parts[1])
    }
}

struct Path2D {
    let hailstone: Hailstone
    let a: Double
    let b: Double
    let c: Double

    init(_ hailstone: Hailstone) {
        self.hailstone = hailstone

        let p1 = hailstone.position
        let p2 = hailstone.position + hailstone.velocity
        self.a = Double(p2.y - p1.y)
        self.b = Double(p1.x - p2.x)
        self.c = Double(p1.y * (p2.x - p1.x) - (p2.y - p1.y) * p1.x)
    }

    func intersection(_ other: Self) -> (x: Int, y: Int)? {
        let divisor = (a * other.b - other.a * b)
        guard divisor != 0 else { return nil }
        let xDouble = (b * other.c - other.b * c) / divisor
        let yDouble = (other.a * c - a * other.c) / divisor
        return (Int(xDouble.rounded()), Int(yDouble.rounded()))
    }

    func isFuturePosition(_ x: Int, _ y: Int) -> Bool {
        let diff = Vector3(x: x, y: y, z: 0) - hailstone.position
        return signsMatch(diff.x, hailstone.velocity.x) && signsMatch(diff.y, hailstone.velocity.y)
    }

    private func signsMatch(_ lhs: Int, _ rhs: Int) -> Bool {
        lhs.signum() == rhs.signum()
    }
}

extension Collection {
    func combinations(of size: Int) -> [[Element]] {
        func pick(_ count: Int, from: ArraySlice<Element>) -> [[Element]] {
            guard count > 0 else { return [] }
            guard count < from.count else { return [Array(from)] }
            if count == 1 {
                return from.map { [$0] }
            } else {
                return from.dropLast(count - 1)
                    .enumerated()
                    .flatMap { pair in
                        return pick(count - 1, from: from.dropFirst(pair.offset + 1)).map { [pair.element] + $0 }
                    }
            }
        }

        return pick(size, from: ArraySlice(self))
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let hailstones = source.lines.map(Hailstone.init)
        let paths = hailstones.map(Path2D.init)
        let result = paths.combinations(of: 2).reduce(into: 0) { result, pair in
            if let (x, y) = pair[0].intersection(pair[1]),
               source.testArea.contains(x) && source.testArea.contains(y),
               pair[0].isFuturePosition(x, y), pair[1].isFuturePosition(x, y)
            {
                result += 1
            }
        }

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
