//
//  ProgressView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI
import Charts

struct ProgressView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPeriod = "Month"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with period selector
                    HStack {
                        Button("Week") {
                            selectedPeriod = "Week"
                        }
                        .foregroundColor(selectedPeriod == "Week" ? .primary : .gray)
                        
                        Button("Shot") {
                            selectedPeriod = "Shot"
                        }
                        .foregroundColor(selectedPeriod == "Shot" ? .primary : .gray)
                        
                        Button("Month") {
                            selectedPeriod = "Month"
                        }
                        .foregroundColor(selectedPeriod == "Month" ? .primary : .gray)
                        .fontWeight(selectedPeriod == "Month" ? .semibold : .regular)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Date Range
                    Text("Apr 5 - Apr 30, 2025")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Overview Stats
                    HStack(spacing: 30) {
                        VStack {
                            Text(String(format: "%+.1f lbs", viewModel.healthData.weightChange))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.green)
                            Text("Since last month")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("30 min")
                                .font(.system(size: 20, weight: .bold))
                            Text("Avg. Workout Duration")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("30 mg")
                                .font(.system(size: 20, weight: .bold))
                            Text("Current Estimate")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Weight Chart
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Weight")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Spacer()
                            
                            Button("Show Stats") {
                                // Action for showing stats
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        Text("\(Int(viewModel.healthData.currentWeight)) lbs")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.green)
                            .padding(.horizontal)
                        
                        // Chart
                        Chart(viewModel.weightEntries) { entry in
                            LineMark(
                                x: .value("Date", entry.date),
                                y: .value("Weight", entry.weight)
                            )
                            .foregroundStyle(.green)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                        .chartYScale(domain: 165...175)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                            }
                        }
                        .chartYAxis {
                            AxisMarks { _ in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel()
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .environmentObject(HealthViewModel())
    }
}
