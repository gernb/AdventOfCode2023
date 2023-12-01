//
//  InputData.swift
//  Day 01
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    static let day = 1

    case example, example2, challenge

    var data: [String] {
        switch self {

        case .example: return """
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
""".components(separatedBy: .newlines)

        case .example2: return """
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
""".components(separatedBy: .newlines)

        case .challenge:
            return try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)

        }
    }
}
