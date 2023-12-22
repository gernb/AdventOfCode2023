//
//  InputData.swift
//  Day 21
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

struct InputData: CustomStringConvertible {
    static let day = 21
    static let part1: [Self] = [.example(6), .challenge(64)]
    static let part2: [Self] = [
        .example(6),
        .example(10),
        .example(50),
        .example(100),
        .example(500),
        .example(1000),
        .example(5000),
        .challenge(26501365)
    ]

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

    static func challenge(_ steps: Int) -> Self {
        .init(
            name: "challenge",
            steps: steps,
            data: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath).trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}
