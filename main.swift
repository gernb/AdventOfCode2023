//
//  main.swift
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

import Foundation

let challenge = (
    (try? String(contentsOfFile: "./input.txt")) ??
    (try? String(contentsOfFile: ("~/Desktop/input.txt" as NSString).expandingTildeInPath))
    )
    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

print("Day \(InputData.day):")
for input in InputData.part1(challenge) {
    input.map(Part1.run)
}
print("")
for input in InputData.part2(challenge) {
    input.map(Part2.run)
}
