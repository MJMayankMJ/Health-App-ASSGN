//
//  DateSelectorView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

// MARK: - Enhanced Date Selector View
struct DateSelectorView: View {
    @State private var selectedDay: Int = 17
    @State private var progressData: [Int: Double] = [
        14: 0.6,  // 60% progress
        15: 0.8,  // 80% progress
        17: 1.0   // 100% progress (but won't show since it's selected)
    ]
    
    let progressColor: Color
    let selectedColor: Color
    let onDateSelected: ((Int) -> Void)?
    
    init(
        selectedDay: Int = 17,
        progressData: [Int: Double] = [:],
        progressColor: Color = .orange,
        selectedColor: Color = .blue,
        onDateSelected: ((Int) -> Void)? = nil
    ) {
        self._selectedDay = State(initialValue: selectedDay)
        self._progressData = State(initialValue: progressData)
        self.progressColor = progressColor
        self.selectedColor = selectedColor
        self.onDateSelected = onDateSelected
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    ForEach(getDayRange(), id: \.self) { day in
                        DateCircleView(
                            day: day,
                            dayName: dayName(for: day),
                            isSelected: day == selectedDay,
                            progress: progressData[day],
                            progressColor: progressColor,
                            selectedColor: selectedColor
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedDay = day
                            }
                            onDateSelected?(day)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                // Auto-scroll to selected day
                withAnimation(.easeInOut(duration: 0.5)) {
                    proxy.scrollTo(selectedDay, anchor: .center)
                }
            }
        }
    }
    
    private func getDayRange() -> [Int] {
        // Get current week or make it dynamic based on your needs
        return Array(11...17)
    }
    
    private func dayName(for day: Int) -> String {
        let days = ["", "", "", "", "", "", "", "", "", "", "", "THU", "FRI", "SAT", "SUN", "MON", "TUE", "WED"]
        guard day < days.count else { return "" }
        return days[day]
    }
}

// MARK: - Individual Date Circle Component
struct DateCircleView: View {
    let day: Int
    let dayName: String
    let isSelected: Bool
    let progress: Double?
    let progressColor: Color
    let selectedColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 6) {
            Text(dayName)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .opacity(isSelected ? 0.8 : 0.6)
            
            Button(action: action) {
                ZStack {
                    // Background circle with shadow
                    Circle()
                        .fill(isSelected ? selectedColor : Color(.systemBackground))
                        .frame(width: 36, height: 36)
                        .shadow(
                            color: isSelected ? selectedColor.opacity(0.3) : Color.black.opacity(0.1),
                            radius: isSelected ? 4 : 2,
                            x: 0,
                            y: isSelected ? 2 : 1
                        )
                    
                    // Progress arc (only for non-selected days with progress)
                    if !isSelected, let progressValue = progress, progressValue > 0 {
                        Circle()
                            .trim(from: 0, to: progressValue)
                            .stroke(
                                progressColor.gradient,
                                style: StrokeStyle(
                                    lineWidth: 3.5,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 32, height: 32)
                            .animation(.easeInOut(duration: 0.3), value: progressValue)
                    }
                    
                    // Border circle for non-selected days
                    if !isSelected {
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 1.5)
                            .frame(width: 36, height: 36)
                    }
                    
                    // Day number
                    Text("\(day)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? .white : .primary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
        }
        .id(day) // For ScrollViewReader
    }
}

// MARK: - Alternative Compact Version
struct CompactDateSelectorView: View {
    @Binding var selectedDay: Int
    let progressData: [Int: Double]
    let dayRange: ClosedRange<Int>
    let progressColor: Color
    let selectedColor: Color
    
    init(
        selectedDay: Binding<Int>,
        progressData: [Int: Double] = [:],
        dayRange: ClosedRange<Int> = 11...17,
        progressColor: Color = .orange,
        selectedColor: Color = .blue
    ) {
        self._selectedDay = selectedDay
        self.progressData = progressData
        self.dayRange = dayRange
        self.progressColor = progressColor
        self.selectedColor = selectedColor
    }
    
    var body: some View {
        LazyHStack(spacing: 16) {
            ForEach(Array(dayRange), id: \.self) { day in
                VStack(spacing: 4) {
                    Text(dayName(for: day))
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedDay = day
                        }
                    } label: {
                        ZStack {
                            // Base circle
                            Circle()
                                .fill(day == selectedDay ? selectedColor : Color.clear)
                                .frame(width: 32, height: 32)
                            
                            // Progress indicator
                            if day != selectedDay, let progress = progressData[day], progress > 0 {
                                ProgressRing(
                                    progress: progress,
                                    color: progressColor,
                                    lineWidth: 2.5,
                                    size: 28
                                )
                            }
                            
                            // Border for unselected
                            if day != selectedDay {
                                Circle()
                                    .stroke(Color(.systemGray5), lineWidth: 1)
                                    .frame(width: 32, height: 32)
                            }
                            
                            // Day text
                            Text("\(day)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(day == selectedDay ? .white : .primary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func dayName(for day: Int) -> String {
        let calendar = Calendar.current
        let today = Date()
        
        // This is a simplified version - you'd want to calculate actual dates
        let days = ["", "", "", "", "", "", "", "", "", "", "", "THU", "FRI", "SAT", "SUN", "MON", "TUE", "WED"]
        guard day < days.count else { return "" }
        return days[day]
    }
}

// MARK: - Reusable Progress Ring Component
struct ProgressRing: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    let size: CGFloat
    
    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .frame(width: size, height: size)
    }
}

// MARK: - Usage Examples and Previews
struct DateSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            Text("Enhanced Date Selector")
                .font(.title2)
                .fontWeight(.semibold)
            
            DateSelectorView(
                selectedDay: 17,
                progressData: [
                    12: 0.3,
                    14: 0.6,
                    15: 0.8,
                    16: 0.45
                ],
                progressColor: .orange,
                selectedColor: .blue
            ) { selectedDay in
                print("Selected day: \(selectedDay)")
            }
            
            Divider()
            
            Text("Compact Version")
                .font(.title3)
                .fontWeight(.medium)
            
            CompactDateSelectorViewExample()
        }
        .padding()
    }
}

struct CompactDateSelectorViewExample: View {
    @State private var selectedDay = 17
    
    var body: some View {
        CompactDateSelectorView(
            selectedDay: $selectedDay,
            progressData: [
                14: 0.6,
                15: 0.8,
                16: 0.3
            ],
            progressColor: .green,
            selectedColor: .blue
        )
    }
}
