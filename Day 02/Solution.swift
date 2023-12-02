//
//  Solution.swift
//  Day 02
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum Cube: String {
    case red, green, blue
}

struct Game {
    let id: Int
    let sets: [[Cube: Int]]

    func isPossible(with bag: [Cube: Int]) -> Bool {
        for `set` in sets {
            if `set`[.red]! > bag[.red]! || `set`[.green]! > bag[.green]! || `set`[.blue]! > bag[.blue]! {
                return false
            }
        }
        return true
    }
}
extension Game {
    init(_ string: any StringProtocol) {
        var parts = string.split(separator: ":")
        let id = Int(String(parts[0].split(separator: " ")[1]))!
        parts = parts[1].split(separator: ";")
        let sets = parts.map { setString in
            setString.split(separator: ",").reduce(into: [Cube.red: 0, .green: 0, .blue: 0]) { result, cubes in
                let cubeParts = cubes.trimmingCharacters(in: .whitespaces).split(separator: " ")
                let cube = Cube(rawValue: String(cubeParts[1]))!
                let count = Int(String(cubeParts[0]))!
                result[cube] = count
            }
        }
        self.init(id: id, sets: sets)
    }
}

enum Part1 {
    static let bag: [Cube: Int] = [
        .red: 12,
        .green: 13,
        .blue: 14,
    ]

    static func run(_ source: InputData) {
        let games = source.data.map(Game.init)
        let possibleGameIds = games.compactMap { game in
            game.isPossible(with: Self.bag) ? game.id : nil
        }

        print("Part 1 (\(source)): \(possibleGameIds.reduce(0, +))")
    }
}

// MARK: - Part 2

extension Dictionary where Key == Cube, Value == Int {
    static let emptyBag: Self = [.red: 0, .green: 0, .blue: 0]

    var power: Int {
        self[.red]! * self[.green]! * self[.blue]!
    }
}

extension Game {
    var minimumBag: [Cube: Int] {
        sets.reduce(into: .emptyBag) { result, `set` in
            `set`.forEach { (key: Cube, value: Int) in
                result[key] = max(value, result[key]!)
            }
        }
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let games = source.data.map(Game.init)
        let powers = games.map(\.minimumBag.power)

        print("Part 2 (\(source)): \(powers.reduce(0, +))")
    }
}
