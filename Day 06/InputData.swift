//
//  InputData.swift
//  Day 06
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    static let day = 6

    case example, challenge

    var data: [String] {
        switch self {

        case .example: return """
Time:      7  15   30
Distance:  9  40  200
""".components(separatedBy: .newlines)

        case .challenge:
            return try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)

        }
    }
}
