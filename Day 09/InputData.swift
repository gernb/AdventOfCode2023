//
//  InputData.swift
//  Day 09
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData {
    static let day = 9
    static let part1 = [
        Self.example,
        Self.challenge,
    ]
    static let part2 = [
        Self.example,
        Self.challenge,
    ]

    static let example = (name: "example", lines: """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
""".components(separatedBy: .newlines))

    static let challenge = (name: "challenge", lines: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines))
}
