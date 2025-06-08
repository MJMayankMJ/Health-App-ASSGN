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
    
    // A helper computed property to find the y-axis range for the chart.
    private var yAxisDomain: ClosedRange<Double> {
        let weights = viewModel.chartData.map { $0.weight }
        guard let minWeight = weights.min(), let maxWeight = weights.max() else {
            return 110...125 // Return a default range if no data
        }
        return (minWeight - 2)...(maxWeight + 2)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    periodSelector().padding(.top)
                    dateRangeNavigator()
                    overviewCard()
                    weightChartCard()
                    Spacer()
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Done") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) { Button(action: {}) { Image(systemName: "plus") } }
            }
        }
    }

    // --- SUBVIEWS ---
    
    @ViewBuilder
    private func periodSelector() -> some View {
        HStack(spacing: 12) {
            // The pills now bind directly to the viewModel's selectedPeriod property.
            PeriodPill(title: "Week", isSelected: viewModel.selectedPeriod == "Week") { viewModel.selectedPeriod = "Week" }
            PeriodPill(title: "Shot", isSelected: viewModel.selectedPeriod == "Shot") { viewModel.selectedPeriod = "Shot" }
            PeriodPill(title: "Month", isSelected: viewModel.selectedPeriod == "Month") { viewModel.selectedPeriod = "Month" }
            Spacer()
            Button(action: {}) { Image(systemName: "chevron.down") }
                .frame(width: 40, height: 40)
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(Circle())
        }
    }

    @ViewBuilder
    private func dateRangeNavigator() -> some View {
        HStack {
            Button(action: {}) { Image(systemName: "chevron.left") }
            Spacer()
            // This logic can be expanded to format the date range based on viewModel.selectedPeriod
             Text("May 10 - June 8, 2025")
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Button(action: {}) { Image(systemName: "chevron.right") }
        }
        .foregroundColor(.secondary)
    }

    @ViewBuilder
    private func overviewCard() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis").foregroundColor(Color(red: 0.9, green: 0.6, blue: 0.2))
                Text("Overview").font(.headline)
            }
            HStack(spacing: 30) {
                let weightChange = viewModel.healthData.weightChange
                StatView(value: String(format: "%.1f lbs", abs(weightChange)), label: "Since last month", trend: weightChange < 0 ? .down : .up)
                StatView(value: "30 min", label: "Avg. Workout Duration")
                StatView(value: "30 mg", label: "Current estimate")
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }

    @ViewBuilder
    private func weightChartCard() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weight").font(.title2.bold())
                Spacer()
                Button("Show Shots") {}.font(.callout).foregroundColor(.blue)
                Button(action: {}) { Image(systemName: "pencil.circle.fill").font(.title2).foregroundColor(Color(.systemGray3)) }
            }
            
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(String(format: "%.1f", viewModel.healthData.currentWeight)).font(.system(size: 32, weight: .bold))
                Text("lbs").font(.headline).foregroundColor(.secondary)
                let weightChange = viewModel.healthData.weightChange
                Text(String(format: "%+.1f", weightChange)).font(.callout.weight(.medium)).foregroundColor(weightChange < 0 ? .green : .red)
                Spacer()
            }

            // The Chart now iterates over the pre-processed `chartData`.
            Chart(viewModel.chartData) { entry in
                // Draws the smooth, curved line.
                LineMark(x: .value("Date", entry.date), y: .value("Weight", entry.weight))
                    .foregroundStyle(.black)
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    .interpolationMethod(.catmullRom)
                
                // Draws the larger orange dot for highlighted points (it's drawn first, so it's in the back).
                if entry.isHighlighted {
                    PointMark(x: .value("Date", entry.date), y: .value("Weight", entry.weight))
                        .foregroundStyle(Color(red: 0.9, green: 0.6, blue: 0.2))
                        .symbolSize(90)
                }
                
                // Draws the small black dot on top of every point.
                PointMark(x: .value("Date", entry.date), y: .value("Weight", entry.weight))
                    .foregroundStyle(.black)
                    .symbolSize(25)
            }
            .frame(height: 200)
            .chartYScale(domain: yAxisDomain)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 5)) { _ in
                    AxisGridLine().foregroundStyle(.clear)
                    AxisTick().foregroundStyle(.clear)
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day(), centered: true).font(.caption).foregroundStyle(.secondary)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine(stroke: StrokeStyle(dash: [3, 3])).foregroundStyle(Color(.systemGray4))
                    AxisValueLabel().font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

// --- HELPER VIEWS ---

struct PeriodPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 20).padding(.vertical, 10)
                .background(isSelected ? Color.black : Color(.secondarySystemGroupedBackground))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(isSelected ? Color.clear : Color(.systemGray4), lineWidth: 1))
        }
    }
}

struct StatView: View {
    let value: String
    let label: String
    var trend: Trend = .none
    enum Trend { case up, down, none }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 2) {
                if trend != .none { Image(systemName: trend == .down ? "arrow.down" : "arrow.up").font(.caption.weight(.bold)) }
                Text(value).font(.title3.weight(.semibold))
            }
            .foregroundColor(trend == .down ? .green : (trend == .up ? .red : .primary))
            Text(label).font(.caption).foregroundColor(.secondary)
        }
    }
}

// --- PREVIEW ---
struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .environmentObject(HealthViewModel())
            .preferredColorScheme(.light)
    }
}
