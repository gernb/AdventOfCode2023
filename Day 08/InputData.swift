//
//  InputData.swift
//  Day 08
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    static let day = 8

    case example, challenge

    var data: [String] {
        switch self {

        case .example: return """
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
""".components(separatedBy: .newlines)

        case .challenge:
            return try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)

        }
    }
}
