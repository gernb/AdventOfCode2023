//
//  InputData.swift
//  Day 20
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

struct InputData: CustomStringConvertible {
    static let day = 20
    static func part1(_ challengeData: String?) -> [Self?] {[
        .example, .example2,
        challengeData.map { Self(name: "challenge", data: $0) }
    ]}
    static func part2(_ challengeData: String?) -> [Self?] {[
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
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
""")

    static let example2 = Self(
        name: "example2",
        data:
"""
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
""")
}
