//
//  HealthViewModel.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI
import Combine


// The user-provided ViewModel to manage health data.
class HealthViewModel: ObservableObject {
    @Published var weightEntries: [WeightEntry]
    @Published var healthData: HealthData
    @Published var showingWeightEntry = false
    @Published var showingProgressView = false
    @Published var currentWeight: Double
    
    // This property will hold the data processed and ready for the chart.
    @Published var chartData: [ChartDataPoint] = []
    
    // The selectedPeriod is now the source of truth in the ViewModel.
    @Published var selectedPeriod = "Month" {
        didSet {
            // Automatically update the chart when the period changes.
            updateChartData()
        }
    }
    
    init() {
        let dummyWeightData = Self.generateDummyWeightData()
        self.weightEntries = dummyWeightData
        
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
        
        // Perform the initial data processing for the chart.
        updateChartData()
    }
    
    /// Generates smoother, more realistic dummy data for the chart preview.
    private static func generateDummyWeightData() -> [WeightEntry] {
        var entries: [WeightEntry] = []
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -29 + i, to: today) {
                // Creates a smooth downward trend with some wave-like variation.
                let progress = Double(i) / 29.0
                let baseWeight = 173.0 - (progress * 3.0)
                let variation = sin(Double(i) * .pi / 6.0) * 0.4
                let weight = baseWeight + variation
                entries.append(WeightEntry(date: date, weight: weight))
            }
        }
        return entries
    }
    
    /// Adds a new weight entry and ensures only the latest entry for a given day is kept.
    func addWeightEntry(weight: Double) {
        let newEntry = WeightEntry(date: Date(), weight: weight)
        let calendar = Calendar.current
        
        // Remove any other entry from the same calendar day before adding the new one.
        weightEntries.removeAll { entry in
            calendar.isDate(entry.date, inSameDayAs: newEntry.date)
        }
        weightEntries.append(newEntry)
        weightEntries.sort { $0.date < $1.date }
        
        // Update the main health data stats.
        if let firstWeight = weightEntries.first?.weight {
            let weightChange = weight - firstWeight
            healthData.currentWeight = weight
            healthData.weightChange = weightChange
            currentWeight = weight
        }
        
        // Refresh the chart with the new data.
        updateChartData()
    }
    
    /// Processes the raw weight entries into a format ready for chart display.
    /// This includes filtering, finding the latest daily entry, and flagging highlighted points.
    private func updateChartData() {
        let calendar = Calendar.current
        
        // 1. Get only the latest entry for each day to prevent duplicates.
        var latestDailyEntriesDict: [Date: WeightEntry] = [:]
        for entry in weightEntries {
            let day = calendar.startOfDay(for: entry.date)
            if let existingEntry = latestDailyEntriesDict[day] {
                if entry.date > existingEntry.date { latestDailyEntriesDict[day] = entry }
            } else {
                latestDailyEntriesDict[day] = entry
            }
        }
        let latestDailyEntries = latestDailyEntriesDict.values.sorted { $0.date < $1.date }
        
        guard !latestDailyEntries.isEmpty else {
            self.chartData = []
            return
        }

        // 2. Create the base ChartDataPoint array.
        var processedData = latestDailyEntries.map { ChartDataPoint(date: $0.date, weight: $0.weight) }

        // 3. Determine which points to highlight.
        guard let firstDate = latestDailyEntries.first?.date, let lastDate = latestDailyEntries.last?.date else {
            self.chartData = processedData
            return
        }
        
        var highlightMarkerDate = firstDate
        while highlightMarkerDate <= lastDate {
            // Find the data point in our array that is closest to the ideal 5-day marker.
            let closestIndex = processedData.indices.min(by: {
                abs(processedData[$0].date.timeIntervalSince(highlightMarkerDate)) < abs(processedData[$1].date.timeIntervalSince(highlightMarkerDate))
            })
            
            // Mark that closest point for highlighting.
            if let index = closestIndex {
                processedData[index].isHighlighted = true
            }
            
            // Advance the marker by 5 days.
            highlightMarkerDate = calendar.date(byAdding: .day, value: 5, to: highlightMarkerDate)!
        }
        
        self.chartData = processedData
    }
}
