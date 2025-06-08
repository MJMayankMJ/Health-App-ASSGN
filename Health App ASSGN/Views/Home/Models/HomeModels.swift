//
//  HomeModels.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

struct WaterData {
    let value: Double
    let unit: String
    let goal: String
}

struct WeightData {
    let value: String
    let changeAmount: Double?
    let isDecrease: Bool
    let goal: String
}

struct WorkoutData {
    let value: String
    let unit: String
    let goal: String
}

struct CaloriesData {
    let value: Double
    let unit: String
    let goal: String
    let breakdown: [(String, String, Color)]?
}

struct ActionData {
    let title: String
    let subtitle: String?
    let description: String?
    let buttonText: String
    let isGradient: Bool
    let backgroundColor: Color
    let icons: [String]?
    let action: () -> Void
}
