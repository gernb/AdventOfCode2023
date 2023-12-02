//
//  InputData.swift
//  Day 02
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    static let day = 2

    case example, challenge

    var data: [String] {
        switch self {

        case .example: return """
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
""".components(separatedBy: .newlines)

        case .challenge:
            return try! String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath)
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)

        }
    }
}
