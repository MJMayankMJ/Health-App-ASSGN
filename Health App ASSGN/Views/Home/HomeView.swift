//
//  HomeView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

// MARK: - Main HomeView
struct HomeView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    @State private var selectedTimeFrame: TimeFrame = .today
    
    enum TimeFrame: CaseIterable {
        case today, sinceLast, weekly
        
        var title: String {
            switch self {
            case .today: return "Today"
            case .sinceLast: return "Since last shot"
            case .weekly: return "Weekly"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HeaderView()
                    DateSelectorView()
                    TimeFrameSelectorView(selectedTimeFrame: $selectedTimeFrame)
                    
                    // Content based on selected time frame
                    Group {
                        switch selectedTimeFrame {
                        case .today:
                            TodayContentView()
                        case .sinceLast:
                            SinceLastShotContentView()
                        case .weekly:
                            WeeklyContentView()
                        }
                    }
                    .environmentObject(viewModel)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $viewModel.showingWeightEntry) {
            WeightEntryView()
                .environmentObject(viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showingProgressView) {
            ProgressView()
                .environmentObject(viewModel)
        }
    }
}


// MARK: - Content Views
struct TodayContentView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Weight and Water Row
            HStack(spacing: 16) {
                WeightCard(data: createWeightData())
                    .environmentObject(viewModel)
                
                WaterCard(data: WaterData(
                    value: 124.5,
                    unit: "ml",
                    goal: "Goal 3.0 L"
                ))
            }
            
            // 2x2 Grid for Calories, Workout, and Calories Burnt
            HStack(spacing: 16) {
                // Left side - Calories card with breakdown
                CaloriesCard(data: CaloriesData(
                    value: 2034.6,
                    unit: "kcal",
                    goal: "Goal 2400 kcal",
                    breakdown: [
                        ("Protein", "30g/100g", .blue),
                        ("Carbs", "100g/250g", .orange),
                        ("Fats", "30g/70g", .red)
                    ]
                ))
                
                // Right side - Workout and Calories Burnt stacked
                VStack(spacing: 16) {
                    WorkoutCard(data: WorkoutData(
                        value: "30",
                        unit: "min",
                        goal: "Goal 45 min"
                    ))
                    
                    CaloriesCard(data: CaloriesData(
                        value: 1000,
                        unit: "kcal",
                        goal: "Goal 1300 kcal",
                        breakdown: nil
                    ), type: .burnt)
                }
            }
            
            // Side Effects Card
            ActionCard(data: ActionData(
                title: "Any side Effects today?",
                subtitle: nil,
                description: "Let us know how you're feeling — it helps track patterns and feel more in control.",
                buttonText: "Log Side Effects",
                isGradient: false,
                backgroundColor: Color(UIColor.systemGray6),
                icons: nil,
                action: { /* Handle side effects logging */ }
            ))
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper function to create WeightData from ViewModel
    private func createWeightData() -> WeightData {
        let currentWeight = viewModel.healthData.currentWeight
        let weightChange = viewModel.healthData.weightChange
        
        // Check if we have any weight entries for today
        let calendar = Calendar.current
        let today = Date()
        let hasEntryToday = viewModel.weightEntries.contains { entry in
            calendar.isDate(entry.date, inSameDayAs: today)
        }
        
        if hasEntryToday || currentWeight > 0 {
            // Format the weight value
            let weightString = String(format: "%.1f", currentWeight)
            
            // Determine if there's a change to show
            if abs(weightChange) > 0.1 { // Only show change if it's significant
                return WeightData(
                    value: weightString,
                    changeAmount: weightChange,
                    isDecrease: weightChange < 0,
                    goal: "Since first entry"
                )
            } else {
                return WeightData(
                    value: weightString,
                    changeAmount: nil,
                    isDecrease: false,
                    goal: "Current weight"
                )
            }
        } else {
            // No weight data available
            return WeightData(
                value: "—",
                changeAmount: nil,
                isDecrease: false,
                goal: "Tap to add weight"
            )
        }
    }
}


struct SinceLastShotContentView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Daily Check-in Card
            ActionCard(data: ActionData(
                title: "Daily Check-in",
                subtitle: "Keep the streak going!",
                description: "Log today's data",
                buttonText: "Add Today's Data",
                isGradient: true,
                backgroundColor: .blue,
                icons: ["bubbles.and.sparkles.fill", "dumbbell.fill", "drop.fill"],
                action: { /* Handle daily check-in */ }
            ))
            
            // Health Metrics Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                WeightCard(data: WeightData(
                    value: "3",
                    changeAmount: -3.0,
                    isDecrease: true,
                    goal: "Since last shot"
                ))
                
                WaterCard(data: WaterData(
                    value: 2700,
                    unit: "ml/day",
                    goal: "Goal 3000 ml/day"
                ))
                
                CaloriesCard(data: CaloriesData(
                    value: viewModel.healthData.caloriesBurnt,
                    unit: "kcal",
                    goal: "Goal 2400 kcal",
                    breakdown: nil
                ), type: .burnt)
                
                CaloriesCard(data: CaloriesData(
                    value: viewModel.healthData.caloriesConsumed,
                    unit: "kcal",
                    goal: "Goal 2000 kcal",
                    breakdown: nil
                ), type: .consumed)
                
                WorkoutCard(data: WorkoutData(
                    value: "\(viewModel.healthData.workoutSessions)",
                    unit: "sessions",
                    goal: "Goal 6 sessions"
                ))
                
                ActionCard(data: ActionData(
                    title: "Time to Next Shot",
                    subtitle: "Today",
                    description: "On 8th May 2025",
                    buttonText: "",
                    isGradient: false,
                    backgroundColor: .white,
                    icons: nil,
                    action: { /* Handle next shot */ }
                ), isCompact: true)
            }
        }
        .padding(.horizontal)
    }
}

struct WeeklyContentView: View {
    var body: some View {
        VStack {
            Text("Weekly view coming soon")
                .font(.title3)
                .foregroundColor(.gray)
                .padding()
        }
    }
}


// MARK: - Previews
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HealthViewModel())
    }
}

struct TodayContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TodayContentView()
        }
        .environmentObject(HealthViewModel())
    }
}

struct SinceLastShotContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            SinceLastShotContentView()
        }
        .environmentObject(HealthViewModel())
    }
}
