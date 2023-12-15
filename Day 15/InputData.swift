//
//  InputData.swift
//  Day 15
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

struct InputData: CustomStringConvertible {
    static let day = 15
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
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
""")

    static let challenge = Self(
        name: "challenge",
        data: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath).trimmingCharacters(in: .whitespacesAndNewlines)
    )
}
