//
//  HealthViewModel.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI
import Combine

class HealthViewModel: ObservableObject {
    @Published var weightEntries: [WeightEntry]
    @Published var healthData: HealthData
    @Published var showingWeightEntry = false
    @Published var showingProgressView = false
    @Published var currentWeight: Double
    
    init() {
        // Generate dummy weight data for the past month first
        let dummyWeightData = Self.generateDummyWeightData()
        self.weightEntries = dummyWeightData
        
        // Set initial health data using the generated weight data
        let latestWeight = dummyWeightData.last?.weight ?? 170.0
        let firstWeight = dummyWeightData.first?.weight ?? 173.0
        let weightChange = latestWeight - firstWeight
        
        self.healthData = HealthData(
            currentWeight: latestWeight,
            weightChange: weightChange,
            waterIntake: 2700,
            caloriesBurnt: 2034.2,
            caloriesConsumed: 2034.2,
            workoutSessions: 3,
            nextShotTime: "Today"
        )
        
        self.currentWeight = latestWeight
    }
    
    private static func generateDummyWeightData() -> [WeightEntry] {
        var entries: [WeightEntry] = []
        let calendar = Calendar.current
        let today = Date()
        
        // Generate 30 days of weight data with gradual weight loss
        for i in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -29 + i, to: today)!
            // Start at 173 lbs and gradually decrease to 170 lbs with some variation
            let baseWeight = 173.0 - (Double(i) * 0.1)
            let variation = Double.random(in: -0.5...0.5)
            let weight = baseWeight + variation
            
            entries.append(WeightEntry(date: date, weight: weight))
        }
        
        return entries
    }
    
    func addWeightEntry(weight: Double) {
        let newEntry = WeightEntry(date: Date(), weight: weight)
        weightEntries.append(newEntry)
        
        // Update health data
        let firstWeight = weightEntries.first?.weight ?? weight
        let weightChange = weight - firstWeight
        
        healthData = HealthData(
            currentWeight: weight,
            weightChange: weightChange,
            waterIntake: healthData.waterIntake,
            caloriesBurnt: healthData.caloriesBurnt,
            caloriesConsumed: healthData.caloriesConsumed,
            workoutSessions: healthData.workoutSessions,
            nextShotTime: healthData.nextShotTime
        )
        
        currentWeight = weight
    }
}
