//
//  InputData.swift
//  Day 07
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData {
    static let day = 7
    static let part1 = [
        Self.example,
        Self.challenge,
    ]
    static let part2 = [
        Self.example,
        Self.challenge,
    ]

    static let example = (name: "example", lines: """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
""".components(separatedBy: .newlines))

    static let challenge = (name: "challenge", lines: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines))
}
