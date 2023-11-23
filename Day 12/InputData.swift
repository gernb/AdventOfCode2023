//
//  InputData.swift
//  Day 12
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    static let day = 12

    case example, challenge

    var data: [String] {
        switch self {

        case .example: return """
""".components(separatedBy: .newlines)

        case .challenge:
            return try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)

        }
    }
}
