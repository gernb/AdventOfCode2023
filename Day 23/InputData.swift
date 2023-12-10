//
//  InputData.swift
//  Day 23
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData {
    static let day = 23
    static let part1 = [
        Self.example,
        Self.challenge,
    ]
    static let part2 = [
        Self.example,
        Self.challenge,
    ]

    static let example = (name: "example", lines: """
""".components(separatedBy: .newlines))

    static let challenge = (name: "challenge", lines: try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines))
}
