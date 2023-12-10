//
//  Solution.swift
//  Day 04
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

struct ScratchCard {
    let id: Int
    let winningNumbers: Set<Int>
    let numbers: [Int]
}
extension ScratchCard {
    init(_ string: String) {
        var parts = string.split(separator: ":")
        let id = Int(String(parts[0].split(separator: " ")[1]))!
        parts = parts[1].split(separator: "|")
        let winningNumbers = parts[0].trimmingCharacters(in: .whitespaces)
            .split(separator: " ")
            .map { Int(String($0))! }
        let numbers = parts[1].trimmingCharacters(in: .whitespaces)
            .split(separator: " ")
            .map { Int(String($0))! }
        self.init(id: id, winningNumbers: Set(winningNumbers), numbers: numbers)
    }
}

enum Part1 {
    static func run(_ source: (name: String, lines: [String])) {
        let cards = source.lines.map(ScratchCard.init)
        let matches = cards.map { card in
            card.numbers.filter { card.winningNumbers.contains($0) }
        }
        let total = matches.map { $0.count > 0 ? pow(2, ($0.count - 1)) : 0 }
            .reduce(0, +)

        print("Part 1 (\(source.name)): \(total)")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: (name: String, lines: [String])) {
        let cards = source.lines.map(ScratchCard.init)
        var cardCounts = Array<Int>(repeating: 1, count: cards.count)
        let matches = cards.map { card in
            card.numbers.filter { card.winningNumbers.contains($0) }
        }
        for (idx, match) in matches.enumerated() {
            let count = cardCounts[idx]
            for n in (idx + 1) ..< (idx + 1 + match.count) {
                cardCounts[n] += count
            }
        }

        print("Part 2 (\(source.name)): \(cardCounts.reduce(0, +))")
    }
}
