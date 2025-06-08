//
//  WeightEntryView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct RulerWeightSlider: View {
    @Binding var weight: Double
    let minWeight: Double = 0
    let maxWeight: Double = 400
    
    @State private var scrollPosition: Double = 170.0
    
    private let tickSpacing: CGFloat = 20 // Wider spacing for better visibility
    private let majorTickHeight: CGFloat = 25
    private let mediumTickHeight: CGFloat = 18
    private let minorTickHeight: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 8) {
            // Range labels
            HStack {
                Text("\(Int(weight - 1))")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("\(Int(weight + 1))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            // Wheel picker using iOS 17 ScrollView
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 80)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // Scrollable ruler
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        // Leading spacer to center first item
                        Spacer()
                            .frame(width: UIScreen.main.bounds.width / 2)
                        
                        // Weight ticks with 0.1 increments
                        ForEach(Int(minWeight * 10)...Int(maxWeight * 10), id: \.self) { weightValue in
                            let weight = Double(weightValue) / 10.0
                            let isWhole = weight.truncatingRemainder(dividingBy: 1) == 0
                            let isHalf = weight.truncatingRemainder(dividingBy: 1) == 0.5
                            
                            VStack(spacing: 4) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 1.5, height: tickHeight(for: weight))
                                
                                if isWhole {
                                    Text("\(Int(weight))")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: tickSpacing)
                            .id(weight)
                        }
                        
                        // Trailing spacer to center last item
                        Spacer()
                            .frame(width: UIScreen.main.bounds.width / 2)
                    }
                }
                .scrollPosition(id: .constant(scrollPosition))
                .scrollTargetBehavior(.paging)
                .onChange(of: scrollPosition) { _, newValue in
                    weight = newValue
                    
                    // Snap to nearest 0.1 and add haptic feedback
                    let snappedWeight = round(newValue * 10) / 10
                    if abs(weight - snappedWeight) > 0.05 {
                        weight = snappedWeight
                        
                        // Haptic feedback for snapping
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }
                }
                
                // Center indicator line
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 2, height: 50)
            }
            .frame(height: 80)
        }
        .onAppear {
            scrollPosition = weight
        }
        .onChange(of: weight) { _, newValue in
            scrollPosition = newValue
        }
    }
    
    private func tickHeight(for weight: Double) -> CGFloat {
        let remainder = weight.truncatingRemainder(dividingBy: 1)
        if remainder == 0 {
            return majorTickHeight // Whole numbers
        } else if remainder == 0.5 {
            return mediumTickHeight // Half numbers
        } else {
            return minorTickHeight // Decimal increments
        }
    }
}

struct WeightEntryView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedWeight: Double = 170.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Weight Icon
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                // Weight Display
                Text("\(Int(selectedWeight))")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.primary)
                
                Text("lb")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                
                // Custom Ruler Slider
                RulerWeightSlider(weight: $selectedWeight)
                    .padding(.horizontal)
                
                // Body Fat Percentage (placeholder)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Body Fat Percentage")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("--")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Progress isn't just numbers — snap a photo to log your journey")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Spacer()
                
                // Record Button
                Button(action: {
                    // Add haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    viewModel.addWeightEntry(weight: selectedWeight)
                    dismiss()
                    
                    // Show progress view after recording
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.showingProgressView = true
                    }
                }) {
                    Text("Record")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.gray)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("Add Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            selectedWeight = viewModel.currentWeight
        }
    }
}

struct WeightEntryView_Previews: PreviewProvider {
    static var previews: some View {
        WeightEntryView()
            .environmentObject(HealthViewModel())
    }
}
