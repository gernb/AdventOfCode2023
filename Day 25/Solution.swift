//
//  Solution.swift
//  Day 25
//
//  Copyright © 2023 peter bohac. All rights reserved.
//

// MARK: - Part 1

func parseComponents(_ lines: [String]) -> [String: Set<String>] {
    lines.reduce(into: [:]) { result, line in
        let parts = line.components(separatedBy: ": ")
        let name = parts[0]
        let connections = parts[1].components(separatedBy: " ")
        result[name, default: []].formUnion(connections)
        connections.forEach { result[$0, default: []].insert(name) }
    }
}

struct Pair<T: Hashable & Comparable>: Hashable {
    let a: T
    let b: T

    init(_ a: T, _ b: T) {
        self.a = min(a, b)
        self.b = max(a, b)
    }

    func map<V>(_ transform: (T) throws -> V) rethrows -> [V] {
        try [a, b].map(transform)
    }
}
extension Pair: CustomStringConvertible where T == String {
    var description: String { "\(a)/\(b)" }
}

func contract(_ graph: [String: Set<String>]) -> (cuts: Set<Pair<String>>, counts: [Int]) {
    let edges: Set<Pair<String>> = graph.reduce(into: []) { result, node in
        let name = node.key
        let connections = node.value
        result.formUnion(connections.map { Pair(name, $0) })
    }

    while true {
        var groups = graph.keys.map { Set([$0]) }
        func groupContaining(node: String) -> Int {
            for (idx, group) in groups.enumerated() {
                if group.contains(node) {
                    return idx
                }
            }
            fatalError()
        }

        for edge in edges.shuffled().lazy where groups.count > 2 {
            let subgroups = edge.map(groupContaining(node:))
            let (g1, g2) = (subgroups[0], subgroups[1])
            guard g1 != g2 else { continue }
            groups[g1].formUnion(groups[g2])
            groups.remove(at: g2)
        }

        let connections = edges.reduce(into: Set<Pair<String>>()) { result, edge in
            let indicies = edge.map(groupContaining(node:))
            if indicies[0] != indicies[1] {
                result.insert(edge)
            }
        }
        if connections.count == 3 {
            return (connections, groups.map(\.count))
        }
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let graph = parseComponents(source.lines)

        let (cuts, counts) = contract(graph)
        print("Part 1 (\(source)):")
        print("  Cuts: \(cuts)")
        print("  Group sizes: \(counts) -> \(counts.reduce(1, *))")
    }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {}
}
