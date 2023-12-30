//
//  InputData.swift
//  Day 09
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

struct InputData: CustomStringConvertible {
    static let day = 9
    static func part1(_ challengeData: String?) -> [Self?] {[
        .example,
        challengeData.map { Self(name: "challenge", data: $0) }
    ]}
    static func part2(_ challengeData: String?) -> [Self?] {[
        .example,
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
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
""")
}
