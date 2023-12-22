//
//  InputData.swift
//  Day 22
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

struct InputData: CustomStringConvertible {
    static let day = 22
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
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
""")

    static let challenge = Self(
        name: "challenge",
        data: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath).trimmingCharacters(in: .whitespacesAndNewlines)
    )
}
