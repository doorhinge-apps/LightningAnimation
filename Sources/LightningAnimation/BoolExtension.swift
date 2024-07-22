// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


extension Bool {
    /// Generate a random Bool returning true with the specified probability
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0..<1) < probability
    }
}
