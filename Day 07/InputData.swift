//
//  InputData.swift
//  Day 07
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    static let day = 7

    case example, challenge

    var data: [String] {
        switch self {

        case .example: return """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
""".components(separatedBy: .newlines)

        case .challenge:
            return try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)

        }
    }
}
