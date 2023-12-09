//
//  InputData.swift
//  Day 09
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    static let day = 9

    case example, challenge

    var data: [String] {
        switch self {

        case .example: return """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
""".components(separatedBy: .newlines)

        case .challenge:
            return try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)

        }
    }
}
