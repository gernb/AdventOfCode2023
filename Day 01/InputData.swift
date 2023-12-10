//
//  InputData.swift
//  Day 01
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

struct InputData: CustomStringConvertible {
    static let day = 1
    static let part1: [Self] = [.example, .challenge]
    static let part2: [Self] = [.example2, .challenge]

    let name: String
    let data: String

    var lines: [String] { data.components(separatedBy: .newlines) }
    var description: String { name }

    static let example = Self(
        name: "example",
        data:
"""
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
""")

    static let example2 = Self(
        name: "example2",
        data:
"""
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
""")

    static let challenge = Self(
        name: "challenge",
        data: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath).trimmingCharacters(in: .whitespacesAndNewlines)
    )
}
