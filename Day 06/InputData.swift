//
//  InputData.swift
//  Day 06
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

struct InputData: CustomStringConvertible {
    static let day = 6
    static let part1: [Self] = [.example, .challenge]
    static let part2: [Self] = [.example, .challenge]

    let name: String
    let data: String

    var lines: [String] { data.components(separatedBy: .newlines) }
    var description: String { name }

    static let example = Self(
        name: "example",
        data:
"""
Time:      7  15   30
Distance:  9  40  200
""")

    static let challenge = Self(
        name: "challenge",
        data: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath).trimmingCharacters(in: .whitespacesAndNewlines)
    )
}
