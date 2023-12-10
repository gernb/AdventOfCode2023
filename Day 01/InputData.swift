//
//  InputData.swift
//  Day 01
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData {
    static let day = 11
    static let part1 = [
        Self.example,
        Self.challenge,
    ]
    static let part2 = [
        Self.example2,
        Self.challenge,
    ]

    static let example = (name: "example", lines: """
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
""".components(separatedBy: .newlines))

    static let example2 = (name: "example2", lines: """
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
""".components(separatedBy: .newlines))

    static let challenge = (name: "challenge", lines: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: .newlines))
}
