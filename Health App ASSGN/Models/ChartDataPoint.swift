//
//  ChartDataPoint.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import Foundation

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
    var isHighlighted: Bool = false
}
