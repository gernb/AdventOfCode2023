//
//  InputData.swift
//  Day 20
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

struct InputData: CustomStringConvertible {
    static let day = 20
    static let part1: [Self] = [.example, .example2, .challenge]
    static let part2: [Self] = [.challenge]

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

    static let challenge = Self(
        name: "challenge",
        data: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath).trimmingCharacters(in: .whitespacesAndNewlines)
    )
}
