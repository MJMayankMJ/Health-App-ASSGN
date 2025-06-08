//
//  WeightEntry.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import Foundation

struct WeightEntry: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
}
