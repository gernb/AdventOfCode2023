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

    var description: String { "(\(x), \(y), \(z))" }

    var down: Self { .init(x: x, y: y, z: z - 1) }
}
extension Vector3 {
    init(_ string: any StringProtocol) {
        let parts = string.components(separatedBy: ",").map { Int($0)! }
        self.init(x: parts[0], y: parts[1], z: parts[2])
    }
}

struct Brick: Hashable {
    var ends: [Vector3]

    var xRange: ClosedRange<Int> { min(ends[0].x, ends[1].x) ... max(ends[0].x, ends[1].x) }
    var yRange: ClosedRange<Int> { min(ends[0].y, ends[1].y) ... max(ends[0].y, ends[1].y) }
    var zRange: ClosedRange<Int> { min(ends[0].z, ends[1].z) ... max(ends[0].z, ends[1].z) }
    var bottom: Int { zRange.lowerBound }

    func movingDown() -> Self { .init(ends: ends.map(\.down)) }
    mutating func moveDown() { self = self.movingDown() }

    func intersects(_ other: Self) -> Bool {
        xRange.overlaps(other.xRange) && yRange.overlaps(other.yRange) && zRange.overlaps(other.zRange)
    }

    func supportedBy(in stack: [Int: Set<Brick>]) -> [Brick] {
        guard bottom > 1 else { return [] }
        let brick = self.movingDown()
        return stack[brick.bottom, default: []].filter { brick.intersects($0) }
    }
}
extension Brick {
    init(_ line: String) {
        let ends = line.split(separator: "~").map(Vector3.init)
        self.init(ends: ends)
    }
}

enum Part1 {
    static func settle(_ brick: inout Brick, in stack: [Int: Set<Brick>]) -> Set<Brick> {
        var below = brick.supportedBy(in: stack)
        while below.isEmpty && brick.bottom > 1 {
            brick.moveDown()
            below = brick.supportedBy(in: stack)
        }
        return Set(below)
    }

    static func buildSupportsMaps(stack: [Brick]) -> (supportsForBrick: [Brick: Set<Brick>], brickIsSupporting: [Brick: Set<Brick>]) {
        var bricksInRow: [Int: Set<Brick>] = [:]
        var supportsForBrick: [Brick: Set<Brick>] = [:]
        var brickIsSupporting: [Brick: Set<Brick>] = [:]
        for var brick in stack {
            let supportedBy = settle(&brick, in: bricksInRow)
            for z in brick.zRange {
                bricksInRow[z, default: []].insert(brick)
            }
            supportsForBrick[brick] = supportedBy
            for below in supportedBy {
                brickIsSupporting[below, default: []].insert(brick)
            }
        }
        return (supportsForBrick, brickIsSupporting)
    }

    static func run(_ source: InputData) {
        let bricks = source.lines.map(Brick.init).sorted(by: { $0.bottom < $1.bottom })
        let (supportsForBrick, brickIsSupporting) = buildSupportsMaps(stack: bricks)

        let result = supportsForBrick.keys.reduce(into: 0) { result, brick in
            let fallingBricks = brickIsSupporting[brick, default: []].filter { supportsForBrick[$0]!.count == 1 }
            result += (fallingBricks.count == 0 ? 1 : 0)
        }

        print("Part 1 (\(source)): \(result)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let bricks = source.lines.map(Brick.init).sorted(by: { $0.bottom < $1.bottom })
        let (supportsForBrick, brickIsSupporting) = Part1.buildSupportsMaps(stack: bricks)

        func remove(_ brick: Brick, removed: inout Set<Brick>) {
            let fallingBricks = brickIsSupporting[brick, default: []].filter { supportsForBrick[$0]!.isSubset(of: removed) }
            removed.formUnion(fallingBricks)
            for brick in fallingBricks {
                remove(brick, removed: &removed)
            }
        }

        let result = supportsForBrick.keys.reduce(into: 0) { result, brick in
            var removed: Set<Brick> = [brick]
            remove(brick, removed: &removed)
            result += removed.count - 1
        }

        print("Part 2 (\(source)): \(result)")
    }
}
