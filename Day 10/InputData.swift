//
//  InputData.swift
//  Day 10
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData {
    static let day = 10
    static let part1 = [
        Self.example,
        Self.example2,
        Self.challenge,
    ]
    static let part2 = [
        Self.example3,
        Self.example4,
        Self.challenge,
    ]

    static let example = (name: "example", lines: """
-L|F7
7S-7|
L|7||
-L-J|
L|-JF
""".components(separatedBy: .newlines))

    static let example2 = (name: "example2", lines: """
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
""".components(separatedBy: .newlines))

    static let example3 = (name: "example3", lines: """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
""".components(separatedBy: .newlines))

    static let example4 = (name: "example4", lines: """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
""".components(separatedBy: .newlines))

    static let challenge = (name: "challenge", lines: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines))
}
