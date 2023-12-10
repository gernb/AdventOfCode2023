//
//  InputData.swift
//  Day 10
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    static let day = 10

    case example, example2, challenge

    var data: [String] {
        switch self {

        case .example: return """
-L|F7
7S-7|
L|7||
-L-J|
L|-JF
""".components(separatedBy: .newlines)

        case .example2: return """
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
""".components(separatedBy: .newlines)

        case .challenge:
            return try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)

        }
    }
}
