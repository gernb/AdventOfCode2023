//
//  InputData.swift
//  Day 08
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

struct InputData: CustomStringConvertible {
    static let day = 8
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
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
""")

    static let example2 = Self(
        name: "example2",
        data:
"""
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
""")
}
