//
//  Solution.swift
//  Day 22
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

struct Vector3: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    var z: Int

    static let zero: Self = .init(x: 0, y: 0, z: 0)

    var description: String { "(\(x), \(y), \(z))" }

    var down: Self { .init(x: x, y: y, z: z - 1) }
}
extension Vector3 {
    init(_ string: any StringProtocol) {
        let parts = string.components(separatedBy: ",").map { Int($0)! }
        self.init(x: parts[0], y: parts[1], z: parts[2])
    }
}

struct Brick {
    var ends: [Vector3]

    var xRange: ClosedRange<Int> { min(ends[0].x, ends[1].x) ... max(ends[0].x, ends[1].x) }
    var yRange: ClosedRange<Int> { min(ends[0].y, ends[1].y) ... max(ends[0].y, ends[1].y) }
    var zRange: ClosedRange<Int> { min(ends[0].z, ends[1].z) ... max(ends[0].z, ends[1].z) }
    var bottom: Int { zRange.lowerBound }
    var top: Int { zRange.upperBound }

    func movingDown() -> Self { .init(ends: ends.map(\.down)) }
    mutating func moveDown() { self = self.movingDown() }

    func intersects(_ other: Self) -> Bool {
        xRange.overlaps(other.xRange) && yRange.overlaps(other.yRange) && zRange.overlaps(other.zRange)
    }

    func canMoveDown(in stack: [Brick]) -> Bool {
        guard bottom > 1 else { return false }
        let brick = self.movingDown()
        for below in stack.bricks(atRow: brick.bottom) {
            if brick.intersects(below) {
                return false
            }
        }
        return true
    }
}
extension Brick {
    init(_ line: String) {
        let ends = line.split(separator: "~").map(Vector3.init)
        self.init(ends: ends)
    }
}

extension Array where Element == Brick {
    func bricks(atRow row: Int) -> [Brick] {
        self.filter { $0.zRange.contains(row) }
    }
}

enum Part1 {
    static func settle(index: Int, stack: inout [Brick]) {
        while stack[index].canMoveDown(in: stack) {
            stack[index].moveDown()
        }
    }

    static func canDisintegrate(index: Int, stack: [Brick]) -> Bool {
        let above = stack.bricks(atRow: stack[index].top + 1)
        var stack = stack
        stack[index] = .init(ends: [.zero, .zero])
        return above.map { $0.canMoveDown(in: stack) }.allSatisfy { $0 == false }
    }

    static func run(_ source: InputData) {
        var bricks = source.lines.map(Brick.init)
        bricks.sort(by: { $0.bottom < $1.bottom })
        for (index, _) in bricks.enumerated() {
            settle(index: index, stack: &bricks)
        }
        let result = bricks.enumerated().reduce(0) { result, pair in
            result + (canDisintegrate(index: pair.offset, stack: bricks) ? 1 : 0)
        }

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

extension Brick: Hashable {}

enum Part2 {
    static func calculateSupports(for stack: [Brick]) -> [Brick: Set<Brick>] {
        stack.reduce(into: [:]) { result, brick in
            guard brick.bottom > 1 else {
                result[brick] = []
                return
            }
            let lowerBrick = brick.movingDown()
            let supportedBy = stack.bricks(atRow: lowerBrick.bottom).compactMap {
                lowerBrick.intersects($0) ? $0 : nil
            }
            result[brick] = Set(supportedBy)
        }
    }

    static func run(_ source: InputData) {
        var bricks = source.lines.map(Brick.init)
        bricks.sort(by: { $0.bottom < $1.bottom })
        for (index, _) in bricks.enumerated() {
            Part1.settle(index: index, stack: &bricks)
        }
        let supportsForBrick = calculateSupports(for: bricks)

        func disintegrate(_ brick: Brick, disintegrated: inout Set<Brick>) {
            let fallingBricks = supportsForBrick
                .filter { (brick: Brick, supportedBy: Set<Brick>) in
                    supportedBy.isEmpty == false &&
                    disintegrated.contains(brick) == false &&
                    supportedBy.isSubset(of: disintegrated)
                }
                .keys
            disintegrated.formUnion(fallingBricks)
            for brick in fallingBricks {
                disintegrate(brick, disintegrated: &disintegrated)
            }
        }
        var countsForBrick: [Brick: Int] = [:]
        for brick in bricks {
            var disintegrated: Set<Brick> = [brick]
            disintegrate(brick, disintegrated: &disintegrated)
            countsForBrick[brick] = disintegrated.count - 1
        }
        let result = countsForBrick.values.reduce(0, +)

        print("Part 2 (\(source)): \(result)")
    }
}
