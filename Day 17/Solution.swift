//
//  Solution.swift
//  Day 17
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Heading {
    case left, up, right, down
}

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

    var description: String { "(\(x), \(y))" }

    var up: Self { .init(x: x, y: y - 1) }
    var down: Self { .init(x: x, y: y + 1) }
    var left: Self { .init(x: x - 1, y: y) }
    var right: Self { .init(x: x + 1, y: y) }

    func left(heading: Heading) -> (Self, Heading) {
        switch heading {
        case .up: (self.left, .left)
        case .down: (self.right, .right)
        case .left: (self.down, .down)
        case .right: (self.up, .up)
        }
    }
    func straight(heading: Heading) -> (Self, Heading) {
        switch heading {
        case .up: (self.up, .up)
        case .down: (self.down, .down)
        case .left: (self.left, .left)
        case .right: (self.right, .right)
        }
    }
    func right(heading: Heading) -> (Self, Heading) {
        switch heading {
        case .up: (self.right, .right)
        case .down: (self.left, .left)
        case .left: (self.up, .up)
        case .right: (self.down, .down)
        }
    }
}

func loadMap(_ lines: [String]) -> [Coordinate: Int] {
    var result: [Coordinate: Int] = [:]
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            result[.init(x: x, y: y)] = Int(String(char))!
        }
    }
    return result
}

enum Part1 {
    struct State: Hashable {
        let coord: Coordinate
        let heading: Heading
        let straightCount: Int

        static var initial: Self { .init(coord: .origin, heading: .right, straightCount: 1) }
        var left: Self {
            let pair = coord.left(heading: heading)
            return .init(coord: pair.0, heading: pair.1, straightCount: 1)
        }
        var right: Self {
            let pair = coord.right(heading: heading)
            return .init(coord: pair.0, heading: pair.1, straightCount: 1)
        }
        var straight: Self {
            let pair = coord.straight(heading: heading)
            return .init(coord: pair.0, heading: pair.1, straightCount: straightCount + 1)
        }
    }

    static func findShortestDistance<Node: Hashable>(from start: Node, using getNextNodes: ((Node) -> [(node: Node, cost: Int)]?)) -> Int {
        var visited: [Node: Int] = [:]
        var queue: [Node: Int] = [start: 0]

        while let (node, currentCost) = queue.min(by: { $0.value < $1.value }) {
            queue.removeValue(forKey: node)
            guard let nextNodes = getNextNodes(node) else {
                return currentCost
            }
            for (nextNode, cost) in nextNodes {
                let newCost = currentCost + cost
                if let previousCost = visited[nextNode], previousCost <= newCost {
                    continue
                }
                if let queuedCost = queue[nextNode], queuedCost <= newCost {
                    continue
                }
                queue[nextNode] = newCost
            }
            visited[node] = currentCost
        }

        // No possible path exists
        fatalError()
    }

    static func run(_ source: InputData) {
        let cityMap = loadMap(source.lines)
        let destination = Coordinate(x: source.lines[0].count - 1, y: source.lines.count - 1)
        let heatLoss = findShortestDistance(from: State.initial) { state in
            guard state.coord != destination else { return nil }
            let nextStates = state.straightCount < 3
                ? [state.left, state.straight, state.right]
                : [state.left, state.right]
            return nextStates.compactMap {
                guard let heat = cityMap[$0.coord] else { return nil }
                return ($0, heat)
            }
        }
        print("Part 1 (\(source)): \(heatLoss)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        let cityMap = loadMap(source.lines)
        let destination = Coordinate(x: source.lines[0].count - 1, y: source.lines.count - 1)
        let heatLoss = Part1.findShortestDistance(from: Part1.State.initial) { state in
            guard state.coord != destination else {
                return state.straightCount >= 4 ? nil : []
            }
            let nextStates =
                if state.straightCount < 4 {
                    [state.straight]
                } else if state.straightCount == 10 {
                    [state.left, state.right]
                } else {
                    [state.left, state.straight, state.right]
                }
            return nextStates.compactMap {
                guard let heat = cityMap[$0.coord] else { return nil }
                return ($0, heat)
            }
        }
        print("Part 2 (\(source)): \(heatLoss)")
    }
}
