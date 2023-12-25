//
//  Solution.swift
//  Day 24
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

struct Vector3: Hashable, CustomStringConvertible {
    var x: Decimal
    var y: Decimal
    var z: Decimal

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
        let parts = line.components(separatedBy: ", ").map { Decimal(string: $0.trimmingCharacters(in: .whitespaces))! }
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
    let a: Decimal
    let b: Decimal
    let c: Decimal

    init(_ hailstone: Hailstone) {
        self.hailstone = hailstone

        let p1 = hailstone.position
        let p2 = hailstone.position + hailstone.velocity
        self.a = p2.y - p1.y
        self.b = p1.x - p2.x
        self.c = p1.y * (p2.x - p1.x) - (p2.y - p1.y) * p1.x
    }

    func intersection(_ other: Self) -> (x: Decimal, y: Decimal)? {
        let divisor = (a * other.b - other.a * b)
        guard divisor != 0 else { return nil }
        let x = (b * other.c - other.b * c) / divisor
        let y = (other.a * c - a * other.c) / divisor
        return (x, y)
    }

    func isFuturePosition(_ x: Decimal, _ y: Decimal) -> Bool {
        let diff = Vector3(x: x, y: y, z: 0) - hailstone.position
        return signsMatch(diff.x, hailstone.velocity.x) && signsMatch(diff.y, hailstone.velocity.y)
    }

    private func signsMatch(_ lhs: Decimal, _ rhs: Decimal) -> Bool {
        lhs.sign == rhs.sign
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

extension Decimal {
    var integer: Int {
        Int(Double(self.formatted().replacingOccurrences(of: ",", with: ""))!.rounded())
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let hailstones = source.lines.map(Hailstone.init)
        let paths = hailstones.map(Path2D.init)
        let result = paths.combinations(of: 2).reduce(into: 0) { result, pair in
            if let (x, y) = pair[0].intersection(pair[1]),
               source.testArea.contains(x.integer) && source.testArea.contains(y.integer),
               pair[0].isFuturePosition(x, y), pair[1].isFuturePosition(x, y)
            {
                result += 1
            }
        }

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

extension Hailstone {
    func addingVelocity(x: Int, y: Int) -> Self {
        var result = self
        result.velocity.x += Decimal(x)
        result.velocity.y += Decimal(y)
        return result
    }

    func findZIntersection(for x: Int, _ y: Int, with other: Hailstone) -> Int? {
        let t1 = self.findIntersectionTime(x, y)
        let t2 = other.findIntersectionTime(x, y)
        guard t1 != t2 else { return nil }
        let z = (self.position.z - other.position.z + Decimal(t1) * self.velocity.z - Decimal(t2) * other.velocity.z) / Decimal(t1 - t2)
        return z.integer
    }

    func findIntersectionTime(_ x: Int, _ y: Int) -> Int {
        (velocity.x == 0 ? (Decimal(y) - position.y) / velocity.y : (Decimal(x) - position.x) / velocity.x).integer
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let hailstones = source.lines.map(Hailstone.init)

        var n = 0
        while true {
            for x in 1 ... n + 1 {
                let y = n - x
                for (negX, negY) in [(1,1), (-1,1), (1,-1), (-1,-1)] {
                    let dx = negX * x
                    let dy = negY * y
                    let first = hailstones[0].addingVelocity(x: dx, y: dy)
                    let path = Path2D(first)
                    var intersection: (x: Decimal, y: Decimal)?
                    var found = true
                    for stone in hailstones.dropFirst() {
                        if let p = path.intersection(.init(stone.addingVelocity(x: dx, y: dy))) {
                            if let previous = intersection, previous != p {
                                found = false
                                break
                            } else {
                                intersection = p
                            }
                        } else {
                            found = false
                            break
                        }
                    }
                    guard found else { continue }
                    let (rockX, rockY) = (intersection!.x.integer, intersection!.y.integer)
                    var dz: Int?
                    for stone in hailstones.dropFirst() {
                        if let z = first.findZIntersection(for: rockX, rockY, with: stone.addingVelocity(x: dx, y: dy)) {
                            if let previous = dz, previous != z {
                                found = false
                                break
                            } else {
                                dz = z
                            }
                        } else {
                            found = false
                            break
                        }
                    }
                    guard found else { continue }
                    let time = first.findIntersectionTime(rockX, rockY)
                    let rockZ = first.position.z.integer + time * (first.velocity.z.integer - dz!)
                    let result = (rockX + rockY + rockZ)
                    print("Part 2 (\(source)): \(result)")
                    return
                }
            }
            n += 1
        }
    }
}
