//
//  InputData.swift
//  Day 21
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

struct InputData: CustomStringConvertible {
    static let day = 21
    static let part1: [Self] = [.example, .challenge]
    static let part2: [Self] = [.example, .challenge]

    let name: String
    let steps: Int
    let data: String

    var lines: [String] { data.components(separatedBy: .newlines) }
    var description: String { name }

    static let example = Self(
        name: "example",
        steps: 6,
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

    static let challenge = Self(
        name: "challenge",
        steps: 64,
        data: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath).trimmingCharacters(in: .whitespacesAndNewlines)
    )
}
