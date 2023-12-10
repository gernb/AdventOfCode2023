//
//  Solution.swift
//  Day 07
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

enum HandType: Int {
    case fiveOfAKind = 7
    case fourOfAKind = 6
    case fullHouse = 5
    case threeOfAKind = 4
    case twoPair = 3
    case onePair = 2
    case highCard = 1
}

struct Hand {
    let hand: String
    let handType: HandType
    let bid: Int

    init(hand: String, bid: Int) {
        self.hand = hand
        self.bid = bid
        self.handType = Self.handType(for: hand)
    }

    private static func handType(for hand: String) -> HandType {
        var sets: [Character: Int] = [:]
        for card in hand {
            sets[card, default: 0] += 1
        }
        if sets.count == 1 {
            return .fiveOfAKind
        }
        if sets.count == 2 {
            let count = sets.first!.value
            if count == 4 || count == 1 {
                return .fourOfAKind
            } else {
                return .fullHouse
            }
        }
        if sets.count == 3 {
            let counts = Set(sets.values)
            if counts.contains(3) {
                return .threeOfAKind
            } else {
                return .twoPair
            }
        }
        if sets.count == 4 {
            return .onePair
        }
        assert(sets.count == 5)
        return .highCard
    }
}
extension Hand: Comparable {
    static let cards = "23456789TJQKA"

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        guard lhs.handType == rhs.handType else {
            return lhs.handType.rawValue < rhs.handType.rawValue
        }
        for pair in zip(lhs.hand, rhs.hand) {
            if pair.0 == pair.1 {
                continue
            }
            let lhsIdx = cards.firstIndex(of: pair.0)!
            let rhsIdx = cards.firstIndex(of: pair.1)!
            return lhsIdx < rhsIdx
        }
        fatalError()
    }
}
extension Hand {
    init(_ string: String) {
        let parts = string.split(separator: " ").map(String.init)
        self.init(hand: parts[0], bid: Int(parts[1])!)
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let hands = source.lines.map(Hand.init)
        let sortedHands = hands.sorted()
        let sum = sortedHands.enumerated().reduce(0) { result, pair in
            result + pair.element.bid * (pair.offset + 1)
        }

        print("Part 1 (\(source)): \(sum)")
    }
}

// MARK: - Part 2

extension Hand {
    var part2HandType: HandType {
        var sets: [Character: Int] = [:]
        for card in hand {
            sets[card, default: 0] += 1
        }
        if sets.count == 1 {
            return .fiveOfAKind
        }
        if sets.count == 2 {
            let count = sets.first!.value
            if count == 4 || count == 1 {
                return hand.contains("J") ? .fiveOfAKind : .fourOfAKind
            } else {
                return hand.contains("J") ? .fiveOfAKind : .fullHouse
            }
        }
        if sets.count == 3 {
            let jCount = hand.filter { $0 == "J" }.count
            if jCount == 3 {
                return .fourOfAKind
            }
            let counts = Set(sets.values)
            if counts.contains(3) {
                return jCount == 1 ? .fourOfAKind : .threeOfAKind
            } else {
                if jCount == 2 {
                    return .fourOfAKind
                }
                return jCount == 1 ? .fullHouse : .twoPair
            }
        }
        if sets.count == 4 {
            let jCount = hand.filter { $0 == "J" }.count
            return jCount > 0 ? .threeOfAKind : .onePair
        }
        assert(sets.count == 5)
        let jCount = hand.filter { $0 == "J" }.count
        return jCount == 1 ? .onePair : .highCard
    }

    static let part2Cards = "J23456789TQKA"

    static func part2Sort(lhs: Hand, rhs: Hand) -> Bool {
        let lhsType = lhs.part2HandType
        let rhsType = rhs.part2HandType
        guard lhsType == rhsType else {
            return lhsType.rawValue < rhsType.rawValue
        }
        for pair in zip(lhs.hand, rhs.hand) {
            if pair.0 == pair.1 {
                continue
            }
            let lhsIdx = part2Cards.firstIndex(of: pair.0)!
            let rhsIdx = part2Cards.firstIndex(of: pair.1)!
            return lhsIdx < rhsIdx
        }
        fatalError()
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let hands = source.lines.map(Hand.init)
        let sortedHands = hands.sorted(by: Hand.part2Sort(lhs:rhs:))
        let sum = sortedHands.enumerated().reduce(0) { result, pair in
            result + pair.element.bid * (pair.offset + 1)
        }

        print("Part 2 (\(source)): \(sum)")
    }
}
