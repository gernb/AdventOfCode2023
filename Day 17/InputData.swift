//
//  InputData.swift
//  Day 17
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

struct InputData: CustomStringConvertible {
    static let day = 17
    static func part1(_ challengeData: String?) -> [Self?] {[
        .example,
        challengeData.map { Self(name: "challenge", data: $0) }
    ]}
    static func part2(_ challengeData: String?) -> [Self?] {[
        .example, .example2,
        challengeData.map { Self(name: "challenge", data: $0) }
    ]}

    let name: String
    let data: String

    var lines: [String] { data.components(separatedBy: .newlines) }
    var description: String { name }

    static let example = Self(
        name: "example",
        data:
"""
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
""")

    static let example2 = Self(
        name: "example2",
        data:
"""
111111111111
999999999991
999999999991
999999999991
999999999991
""")
}
