//
//  InputData.swift
//  Day 01
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

struct InputData: CustomStringConvertible {
    static let day = 1
    static func part1(_ challengeData: String?) -> [Self?] {[
        .example,
        challengeData.map { Self(name: "challenge", data: $0) }
    ]}
    static func part2(_ challengeData: String?) -> [Self?] {[
        .example2,
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
}
