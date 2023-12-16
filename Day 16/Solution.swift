//
//  Solution.swift
//  Day 16
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Heading {
    case left, up, right, down

    var left: Self {
        switch self {
        case .left: return .down
        case .up: return .left
        case .right: return .up
        case .down: return .right
        }
    }

    var right: Self {
        switch self {
        case .left: return .up
        case .up: return .right
        case .right: return .down
        case .down: return .left
        }
    }
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

    func next(heading: Heading) -> Self {
        switch heading {
        case .up: self.up
        case .down: self.down
        case .left: self.left
        case .right: self.right
        }
    }
}

func loadLayout(_ lines: [String]) -> [Coordinate: Character] {
    var result: [Coordinate: Character] = [:]
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            result[.init(x: x, y: y)] = char
        }
    }
    return result
}

enum Part1 {
    static func traceBeam(in layout: [Coordinate: Character]) -> [Coordinate: Int] {
        struct State: Hashable {
            let coord: Coordinate
            let heading: Heading
        }

        var seen: Set<State> = []
        var counts: [Coordinate: Int] = [:]
        func move(to state: State) {
            if seen.contains(state) { return }
            seen.insert(state)
            guard let tile = layout[state.coord] else { return }
            counts[state.coord, default: 0] += 1
            switch (tile, state.heading) {
            case (".", _):
                move(to: .init(coord: state.coord.next(heading: state.heading), heading: state.heading))

            case ("/", .right):
                move(to: .init(coord: state.coord.next(heading: .up), heading: .up))
            case ("/", .left):
                move(to: .init(coord: state.coord.next(heading: .down), heading: .down))
            case ("/", .up):
                move(to: .init(coord: state.coord.next(heading: .right), heading: .right))
            case ("/", .down):
                move(to: .init(coord: state.coord.next(heading: .left), heading: .left))

            case ("\\", .right):
                move(to: .init(coord: state.coord.next(heading: .down), heading: .down))
            case ("\\", .left):
                move(to: .init(coord: state.coord.next(heading: .up), heading: .up))
            case ("\\", .up):
                move(to: .init(coord: state.coord.next(heading: .left), heading: .left))
            case ("\\", .down):
                move(to: .init(coord: state.coord.next(heading: .right), heading: .right))

            case ("|", .up), ("|", .down):
                move(to: .init(coord: state.coord.next(heading: state.heading), heading: state.heading))
            case ("|", .left), ("|", .right):
                move(to: .init(coord: state.coord.next(heading: .up), heading: .up))
                move(to: .init(coord: state.coord.next(heading: .down), heading: .down))

            case ("-", .left), ("-", .right):
                move(to: .init(coord: state.coord.next(heading: state.heading), heading: state.heading))
            case ("-", .up), ("-", .down):
                move(to: .init(coord: state.coord.next(heading: .left), heading: .left))
                move(to: .init(coord: state.coord.next(heading: .right), heading: .right))

            default:
                fatalError()
            }
        }

        move(to: .init(coord: .origin, heading: .right))
        return counts
    }

    static func run(_ source: InputData) {
        let layout = loadLayout(source.lines)
        let counts = traceBeam(in: layout)

        print("Part 1 (\(source)): \(counts.values.count)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)):")
    }
}
