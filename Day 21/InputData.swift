//
//  InputData.swift
//  Day 21
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

struct InputData: CustomStringConvertible {
    static let day = 21
    static func part1(_ challengeData: String?) -> [Self?] {[
        .example(6),
        challengeData.map { Self(name: "challenge", steps: 64, data: $0) }
    ]}
    static func part2(_ challengeData: String?) -> [Self?] {[
        .example(6),
        .example(10),
        .example(50),
        .example(100),
        .example(500),
        .example(1000),
        .example(5000),
        challengeData.map { Self(name: "challenge", steps: 26501365, data: $0) }
    ]}

    let name: String
    let steps: Int
    let data: String

    var lines: [String] { data.components(separatedBy: .newlines) }
    var description: String { name }

    static func example(_ steps: Int) -> Self {
        .init(
            name: "example",
            steps: steps,
            data:
"""
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
""")
    }
}
