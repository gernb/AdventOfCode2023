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

    func signs(equal other: Self) -> Bool {
        x.sign == other.x.sign && y.sign == other.y.sign // && z.sign == other.z.sign
    }

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

    /*
     x = Ap.x + t1 * Av.x
     x = Bp.x + t2 * Bv.x

     y = Ap.y + t1 * Av.y
     y = Bp.y + t2 * Bv.y

     Ap.x + t1 * Av.x = Bp.x + t2 * Bv.x
     t1 = (Bp.x + t2 * Bv.x - Ap.x) / Av.x

     Ap.y + t1 * Av.y = Bp.y + t2 * Bv.y
     t1 = (Bp.y + t2 * Bv.y - Ap.y) / Av.y

     (Bp.x + t2 * Bv.x - Ap.x) / Av.x = (Bp.y + t2 * Bv.y - Ap.y) / Av.y
     Av.y * (Bp.x + t2 * Bv.x - Ap.x) = Av.x * (Bp.y + t2 * Bv.y - Ap.y)
     Av.y * Bp.x + Av.y * Bv.x * t2 - Av.y * Ap.x = Av.x * Bp.y + Av.x * Bv.y * t2 - Av.x * Ap.y
     Av.y * Bv.x * t2 - Av.x * Bv.y * t2 = Av.x * Bp.y - Av.x * Ap.y - (Av.y * Bp.x - Av.y * Ap.x)
     t2 * (Av.y * Bv.x - Av.x * Bv.y) = Av.x * (Bp.y - Ap.y) - Av.y * (Bp.x - Ap.x)
     t2 = Av.x * (Bp.y - Ap.y) - Av.y * (Bp.x - Ap.x) / (Av.y * Bv.x - Av.x * Bv.y)
     */
    func intersection2(_ other: Self) -> (x: Decimal, y: Decimal)? {
        let divisor = self.velocity.y * other.velocity.x - self.velocity.x * other.velocity.y
        guard divisor != 0 else { return nil }
        let t2 = (self.velocity.x * (other.position.y - self.position.y) - self.velocity.y * (other.position.x - self.position.x)) / divisor
        let t1 = self.velocity.x == 0
            ? (other.position.y + t2 * other.velocity.y - self.position.y) / self.velocity.y
            : (other.position.x + t2 * other.velocity.x - self.position.x) / self.velocity.x
        let x = self.position.x + t1 * self.velocity.x
        let y = self.position.y + t1 * self.velocity.y
//        assert((x == (other.position.x + t2 * other.velocity.x)) && (y == (other.position.y + t2 * other.velocity.y)))

        let d1 = Vector3(x: x, y: y, z: 0) - self.position
        let d2 = Vector3(x: x, y: y, z: 0) - other.position
        if self.velocity.signs(equal: d1) && other.velocity.signs(equal: d2) {
            return (x, y)
        } else {
            return nil // intersection happens in the past
        }
    }
}
extension Hailstone {
    init(_ line: String) {
        let parts = line.split(separator: " @ ").map(Vector3.init)
        self.init(position: parts[0], velocity: parts[1])
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
        Int(Double(self.description)!.rounded())
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let hailstones = source.lines.map(Hailstone.init)
        let result = hailstones.combinations(of: 2).reduce(into: 0) { result, pair in
            if let (x, y) = pair[0].intersection2(pair[1]), source.testArea.contains(x.integer) && source.testArea.contains(y.integer) {
                result += 1
            }
        }

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

extension Vector3 {
    static func * (_ lhs: Self, _ scalar: Decimal) -> Self {
        .init(x: lhs.x * scalar, y: lhs.y * scalar, z: lhs.z * scalar)
    }
}

extension Hailstone {
    func addingVelocity(_ v: Vector3) -> Self {
        .init(position: position, velocity: velocity + v)
    }

    func findZIntersection(for x: Decimal, _ y: Decimal, with other: Hailstone) -> Decimal? {
        let t1 = self.time(for: .init(x: x, y: y, z: 0))
        let t2 = other.time(for: .init(x: x, y: y, z: 0))
        guard t1 != t2 else { return nil }
        return (self.position.z - other.position.z + t1 * self.velocity.z - t2 * other.velocity.z) / (t1 - t2)
    }

    func time(for location: Vector3) -> Decimal {
        velocity.x == 0 ? (location.y - position.y) / velocity.y : (location.x - position.x) / velocity.x
    }

    func location(at time: Decimal) -> Vector3 {
        position + velocity * time
    }

    func intersection3(_ other: Self) -> Vector3? {
        let divisor = self.velocity.y * other.velocity.x - self.velocity.x * other.velocity.y
        guard divisor != 0 else { return nil }
        let s = (self.velocity.x * (other.position.y - self.position.y) - self.velocity.y * (other.position.x - self.position.x)) / divisor
        let t = self.velocity.x != 0
            ? (other.position.x + s * other.velocity.x - self.position.x) / self.velocity.x
            : (other.position.y + s * other.velocity.y - self.position.y) / self.velocity.y
        if self.position.z + t * self.velocity.z == other.position.z + s * other.velocity.z {
            return location(at: t)
        } else {
            return nil
        }
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let hailstones = source.lines.map(Hailstone.init)

        var rock: Hailstone?
        var visited = Set([Vector3(x: 0, y: 0, z: 0)])
        var n = 0
        while rock == nil {
            n += 1

// This solution is too slow:
//            print(n)
//            for (dx, dy, dz) in (-n ... n).flatMap({ x in (-n ... n).flatMap { y in (-n ... n).map { (x, y, $0) } } }) {
//                let dv = Vector3(x: Decimal(dx), y: Decimal(dy), z: Decimal(dz))
//                guard visited.contains(dv) == false else { continue }
//                visited.insert(dv)
//                let first = hailstones[0].addingVelocity(dv)
//                let stones = [
//                    hailstones[1].addingVelocity(dv),
//                    hailstones[2].addingVelocity(dv),
//                ]
//                var intersection: Vector3?
//                for stone in stones {
//                    if let p = first.intersection3(stone) {
//                        if let previous = intersection, p != previous {
//                            intersection = nil
//                            break
//                        } else {
//                            intersection = p
//                        }
//                    } else {
//                        intersection = nil
//                        break
//                    }
//                }
//                guard let intersection else { continue }
//                rock = .init(
//                    position: intersection,
//                    velocity: dv * -1
//                )
//                break
//            }

            for (dx, dy) in (-n ... n).flatMap({ x in (-n ... n).map { (x, $0) } }) {
                let dv = Vector3(x: Decimal(dx), y: Decimal(dy), z: 0)
                guard visited.contains(dv) == false else { continue }
                visited.insert(dv)

                let first = hailstones[0].addingVelocity(dv)
                var intersection: (x: Decimal, y: Decimal)?
                for stone in hailstones.dropFirst() {
                    if let p = first.intersection2(stone.addingVelocity(dv)) {
                        if let previous = intersection, previous != p {
                            intersection = nil
                            break
                        } else {
                            intersection = p
                        }
                    } else {
                        intersection = nil
                        break
                    }
                }
                guard let intersection else { continue }
                var dz: Decimal?
                for stone in hailstones.dropFirst() {
                    if let z = first.findZIntersection(for: intersection.x, intersection.y, with: stone.addingVelocity(dv)) {
                        if let previous = dz, previous != z {
                            dz = nil
                            break
                        } else {
                            dz = z
                        }
                    } else {
                        dz = nil
                        break
                    }
                }
                guard let dz else { continue }
                let time = first.time(for: .init(x: intersection.x, y: intersection.y, z: 0))
                let z = first.position.z + time * (first.velocity.z - dz)
                rock = .init(
                    position: .init(x: intersection.x, y: intersection.y, z: z),
                    velocity: .init(x: Decimal(-dx), y: Decimal(-dy), z: dz)
                )
                break
            }
        }

        let result = (rock!.position.x + rock!.position.y + rock!.position.z)
        print("Part 2 (\(source)): \(result)")
    }
}
