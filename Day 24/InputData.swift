//
//  InputData.swift
//  Day 24
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

struct InputData: CustomStringConvertible {
    static let day = 24
    static let part1: [Self] = [.example, .challenge]
    static let part2: [Self] = [.example, .challenge]

    let name: String
    let testArea: ClosedRange<Int>
    let data: String

    var lines: [String] { data.components(separatedBy: .newlines) }
    var description: String { name }

    static let example = Self(
        name: "example",
        testArea: 7 ... 27,
        data:
"""
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
""")

    static let challenge = Self(
        name: "challenge",
        testArea: 200000000000000 ... 400000000000000,
        data: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath).trimmingCharacters(in: .whitespacesAndNewlines)
    )
}
