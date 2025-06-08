//
//  x.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//


//import SwiftUI
//import Charts
//
//// MARK: - ContentView.swift (Main App Entry Point)
//struct ContentView: View {
//    @StateObject private var viewModel = HealthViewModel()
//    
//    var body: some View {
//        TabView {
//            HomeView()
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("Home")
//                }
//                .environmentObject(viewModel)
//            
//            EmptyTabView(title: "Progress")
//                .tabItem {
//                    Image(systemName: "chart.line.uptrend.xyaxis")
//                    Text("Progress")
//                }
//            
//            EmptyTabView(title: "Calendar")
//                .tabItem {
//                    Image(systemName: "calendar")
//                    Text("Calendar")
//                }
//            
//            EmptyTabView(title: "Profile")
//                .tabItem {
//                    Image(systemName: "person.fill")
//                    Text("Profile")
//                }
//        }
//        .accentColor(.blue)
//    }
//}
//
//// MARK: - Models/WeightEntry.swift
//struct WeightEntry: Identifiable {
//    let id = UUID()
//    let date: Date
//    let weight: Double
//}
//
//// MARK: - Models/HealthData.swift
//struct HealthData {
//    let currentWeight: Double
//    let weightChange: Double
//    let waterIntake: Double
//    let caloriesBurnt: Double
//    let caloriesConsumed: Double
//    let workoutSessions: Int
//    let nextShotTime: String
//}
//
//// MARK: - ViewModels/HealthViewModel.swift
//class HealthViewModel: ObservableObject {
//    @Published var weightEntries: [WeightEntry]
//    @Published var healthData: HealthData
//    @Published var showingWeightEntry = false
//    @Published var showingProgressView = false
//    @Published var currentWeight: Double
//    
//    init() {
//        // Generate dummy weight data for the past month first
//        let dummyWeightData = Self.generateDummyWeightData()
//        self.weightEntries = dummyWeightData
//        
//        // Set initial health data using the generated weight data
//        let latestWeight = dummyWeightData.last?.weight ?? 170.0
//        let firstWeight = dummyWeightData.first?.weight ?? 173.0
//        let weightChange = latestWeight - firstWeight
//        
//        self.healthData = HealthData(
//            currentWeight: latestWeight,
//            weightChange: weightChange,
//            waterIntake: 2700,
//            caloriesBurnt: 2034.2,
//            caloriesConsumed: 2034.2,
//            workoutSessions: 3,
//            nextShotTime: "Today"
//        )
//        
//        self.currentWeight = latestWeight
//    }
//    
//    private static func generateDummyWeightData() -> [WeightEntry] {
//        var entries: [WeightEntry] = []
//        let calendar = Calendar.current
//        let today = Date()
//        
//        // Generate 30 days of weight data with gradual weight loss
//        for i in 0..<30 {
//            let date = calendar.date(byAdding: .day, value: -29 + i, to: today)!
//            // Start at 173 lbs and gradually decrease to 170 lbs with some variation
//            let baseWeight = 173.0 - (Double(i) * 0.1)
//            let variation = Double.random(in: -0.5...0.5)
//            let weight = baseWeight + variation
//            
//            entries.append(WeightEntry(date: date, weight: weight))
//        }
//        
//        return entries
//    }
//    
//    func addWeightEntry(weight: Double) {
//        let newEntry = WeightEntry(date: Date(), weight: weight)
//        weightEntries.append(newEntry)
//        
//        // Update health data
//        let firstWeight = weightEntries.first?.weight ?? weight
//        let weightChange = weight - firstWeight
//        
//        healthData = HealthData(
//            currentWeight: weight,
//            weightChange: weightChange,
//            waterIntake: healthData.waterIntake,
//            caloriesBurnt: healthData.caloriesBurnt,
//            caloriesConsumed: healthData.caloriesConsumed,
//            workoutSessions: healthData.workoutSessions,
//            nextShotTime: healthData.nextShotTime
//        )
//        
//        currentWeight = weight
//    }
//}
//
//// MARK: - Views/HomeView.swift
//struct HomeView: View {
//    @EnvironmentObject var viewModel: HealthViewModel
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Header
//                    HStack {
//                        Text("Your GLP-1 Journey")
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                        
//                        Spacer()
//                        
//                        Text("Track your goals, step by step")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.horizontal)
//                    
//                    // Date selector
//                    HStack {
//                        ForEach(11...17, id: \.self) { day in
//                            VStack {
//                                Text("\(day)")
//                                    .font(.caption)
//                                    .foregroundColor(day == 17 ? .white : .gray)
//                                
//                                Circle()
//                                    .fill(day == 17 ? Color.blue : Color.clear)
//                                    .frame(width: 30, height: 30)
//                                    .overlay(
//                                        Text("\(day)")
//                                            .font(.system(size: 14, weight: .medium))
//                                            .foregroundColor(day == 17 ? .white : .primary)
//                                    )
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    // Time period selector
//                    HStack {
//                        TimeButton(title: "Today", isSelected: true)
//                        TimeButton(title: "Since last shot", isSelected: false)
//                        TimeButton(title: "Weekly", isSelected: false)
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    
//                    // Daily Check-in Card
//                    DailyCheckinCard()
//                        .padding(.horizontal)
//                    
//                    // Health Metrics Grid
//                    LazyVGrid(columns: [
//                        GridItem(.flexible()),
//                        GridItem(.flexible())
//                    ], spacing: 16) {
//                        WeightCard(
//                            weight: viewModel.healthData.currentWeight,
//                            change: viewModel.healthData.weightChange
//                        ) {
//                            viewModel.showingWeightEntry = true
//                        }
//                        
//                        WaterCard(intake: viewModel.healthData.waterIntake)
//                        
//                        CaloriesCard(
//                            title: "Calories Burnt",
//                            value: viewModel.healthData.caloriesBurnt,
//                            color: .orange
//                        )
//                        
//                        CaloriesCard(
//                            title: "Calories Consumed",
//                            value: viewModel.healthData.caloriesConsumed,
//                            color: .gray
//                        )
//                        
//                        WorkoutCard(sessions: viewModel.healthData.workoutSessions)
//                        
//                        NextShotCard(time: viewModel.healthData.nextShotTime)
//                    }
//                    .padding(.horizontal)
//                }
//            }
//            .navigationBarHidden(true)
//        }
//        .sheet(isPresented: $viewModel.showingWeightEntry) {
//            WeightEntryView()
//                .environmentObject(viewModel)
//        }
//        .fullScreenCover(isPresented: $viewModel.showingProgressView) {
//            ProgressView()
//                .environmentObject(viewModel)
//        }
//    }
//}
//
//// MARK: - Views/Components/TimeButton.swift
//struct TimeButton: View {
//    let title: String
//    let isSelected: Bool
//    
//    var body: some View {
//        Text(title)
//            .font(.system(size: 14, weight: .medium))
//            .foregroundColor(isSelected ? .white : .gray)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 8)
//            .background(isSelected ? Color.black : Color.clear)
//            .cornerRadius(20)
//    }
//}
//
//// MARK: - Views/Components/DailyCheckinCard.swift
//struct DailyCheckinCard: View {
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                HStack {
//                    Image(systemName: "checkmark.circle.fill")
//                        .foregroundColor(.white)
//                    Text("Daily Check-in")
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(.white)
//                }
//                
//                Text("Keep the streak going!")
//                    .font(.caption)
//                    .foregroundColor(.white.opacity(0.8))
//                
//                Text("Log today's data")
//                    .font(.caption)
//                    .foregroundColor(.white.opacity(0.8))
//            }
//            
//            Spacer()
//            
//            Button("Add Today's Data") {
//                // Action for adding today's data
//            }
//            .font(.system(size: 12, weight: .medium))
//            .foregroundColor(.blue)
//            .padding(.horizontal, 12)
//            .padding(.vertical, 6)
//            .background(Color.white)
//            .cornerRadius(12)
//        }
//        .padding()
//        .background(
//            LinearGradient(
//                colors: [Color.blue, Color.blue.opacity(0.8)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
//        .cornerRadius(16)
//    }
//}
//
//// MARK: - Views/Components/WeightCard.swift
//struct WeightCard: View {
//    let weight: Double
//    let change: Double
//    let action: () -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image(systemName: "scalemass.fill")
//                    .foregroundColor(.gray)
//                Text("Weight")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.gray)
//                Spacer()
//            }
//            
//            Text(String(format: "%.1f lbs", weight))
//                .font(.system(size: 24, weight: .bold))
//            
//            HStack {
//                Text(String(format: "%+.1f lbs", change))
//                    .font(.system(size: 12, weight: .medium))
//                    .foregroundColor(change < 0 ? .green : .red)
//                
//                Spacer()
//                
//                Text("Since last shot")
//                    .font(.system(size: 10))
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
//        .onTapGesture {
//            action()
//        }
//    }
//}
//
//// MARK: - Views/Components/WaterCard.swift
//struct WaterCard: View {
//    let intake: Double
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image(systemName: "drop.fill")
//                    .foregroundColor(.blue)
//                Text("Water")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.gray)
//                Spacer()
//            }
//            
//            Text("\(Int(intake)) ml/day")
//                .font(.system(size: 20, weight: .bold))
//            
//            Text("Goal: 3000 ml/day")
//                .font(.system(size: 10))
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
//    }
//}
//
//// MARK: - Views/Components/CaloriesCard.swift
//struct CaloriesCard: View {
//    let title: String
//    let value: Double
//    let color: Color
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image(systemName: "flame.fill")
//                    .foregroundColor(color)
//                Text(title)
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.gray)
//                Spacer()
//            }
//            
//            Text(String(format: "%.1f kcal", value))
//                .font(.system(size: 18, weight: .bold))
//            
//            Text("Last 24 hrs")
//                .font(.system(size: 10))
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
//    }
//}
//
//// MARK: - Views/Components/WorkoutCard.swift
//struct WorkoutCard: View {
//    let sessions: Int
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image(systemName: "figure.run")
//                    .foregroundColor(.purple)
//                Text("Workout")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.gray)
//                Spacer()
//            }
//            
//            Text("\(sessions) sessions")
//                .font(.system(size: 18, weight: .bold))
//            
//            Text("This week")
//                .font(.system(size: 10))
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
//    }
//}
//
//// MARK: - Views/Components/NextShotCard.swift
//struct NextShotCard: View {
//    let time: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Image(systemName: "clock.fill")
//                    .foregroundColor(.blue)
//                Text("Time to Next Shot")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.gray)
//                Spacer()
//            }
//            
//            Text(time)
//                .font(.system(size: 18, weight: .bold))
//            
//            Text("Schedule")
//                .font(.system(size: 10))
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
//    }
//}
//
//// MARK: - Views/WeightEntryView.swift
//struct WeightEntryView: View {
//    @EnvironmentObject var viewModel: HealthViewModel
//    @Environment(\.dismiss) private var dismiss
//    @State private var selectedWeight: Double = 170.0
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 30) {
//                Spacer()
//                
//                // Weight Icon
//                Image(systemName: "scalemass.fill")
//                    .font(.system(size: 60))
//                    .foregroundColor(.gray)
//                
//                // Weight Display
//                Text("\(Int(selectedWeight))")
//                    .font(.system(size: 80, weight: .light))
//                    .foregroundColor(.primary)
//                
//                Text("lb")
//                    .font(.system(size: 20))
//                    .foregroundColor(.gray)
//                
//                // Weight Slider
//                VStack {
//                    HStack {
//                        Text("169")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        
//                        Spacer()
//                        
//                        Text("171")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.horizontal)
//                    
//                    Slider(value: $selectedWeight, in: 160...180, step: 0.1)
//                        .accentColor(.green)
//                        .padding(.horizontal)
//                }
//                
//                // Body Fat Percentage (placeholder)
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Body Fat Percentage")
//                        .font(.system(size: 16, weight: .medium))
//                    
//                    Text("--")
//                        .font(.system(size: 24, weight: .bold))
//                    
//                    Text("Progress isn't just numbers — snap a photo to log your journey")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.leading)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
//                
//                Spacer()
//                
//                // Record Button
//                Button(action: {
//                    // Add haptic feedback
//                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
//                    impactFeedback.impactOccurred()
//                    
//                    viewModel.addWeightEntry(weight: selectedWeight)
//                    dismiss()
//                    
//                    // Show progress view after recording
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        viewModel.showingProgressView = true
//                    }
//                }) {
//                    Text("Record")
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 16)
//                        .background(Color.gray)
//                        .cornerRadius(12)
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 30)
//            }
//            .navigationTitle("Add Weight")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//        .onAppear {
//            selectedWeight = viewModel.currentWeight
//        }
//    }
//}
//
//// MARK: - Views/ProgressView.swift
//struct ProgressView: View {
//    @EnvironmentObject var viewModel: HealthViewModel
//    @Environment(\.dismiss) private var dismiss
//    @State private var selectedPeriod = "Month"
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Header with period selector
//                    HStack {
//                        Button("Week") {
//                            selectedPeriod = "Week"
//                        }
//                        .foregroundColor(selectedPeriod == "Week" ? .primary : .gray)
//                        
//                        Button("Shot") {
//                            selectedPeriod = "Shot"
//                        }
//                        .foregroundColor(selectedPeriod == "Shot" ? .primary : .gray)
//                        
//                        Button("Month") {
//                            selectedPeriod = "Month"
//                        }
//                        .foregroundColor(selectedPeriod == "Month" ? .primary : .gray)
//                        .fontWeight(selectedPeriod == "Month" ? .semibold : .regular)
//                        
//                        Spacer()
//                        
//                        Button(action: {}) {
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    // Date Range
//                    Text("Apr 5 - Apr 30, 2025")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal)
//                    
//                    // Overview Stats
//                    HStack(spacing: 30) {
//                        VStack {
//                            Text(String(format: "%+.1f lbs", viewModel.healthData.weightChange))
//                                .font(.system(size: 20, weight: .bold))
//                                .foregroundColor(.green)
//                            Text("Since last month")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        VStack {
//                            Text("30 min")
//                                .font(.system(size: 20, weight: .bold))
//                            Text("Avg. Workout Duration")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        VStack {
//                            Text("30 mg")
//                                .font(.system(size: 20, weight: .bold))
//                            Text("Current Estimate")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    // Weight Chart
//                    VStack(alignment: .leading, spacing: 10) {
//                        HStack {
//                            Text("Weight")
//                                .font(.system(size: 18, weight: .semibold))
//                            
//                            Spacer()
//                            
//                            Button("Show Stats") {
//                                // Action for showing stats
//                            }
//                            .font(.caption)
//                            .foregroundColor(.blue)
//                        }
//                        .padding(.horizontal)
//                        
//                        Text("\(Int(viewModel.healthData.currentWeight)) lbs")
//                            .font(.system(size: 16, weight: .medium))
//                            .foregroundColor(.green)
//                            .padding(.horizontal)
//                        
//                        // Chart
//                        Chart(viewModel.weightEntries) { entry in
//                            LineMark(
//                                x: .value("Date", entry.date),
//                                y: .value("Weight", entry.weight)
//                            )
//                            .foregroundStyle(.green)
//                            .lineStyle(StrokeStyle(lineWidth: 2))
//                        }
//                        .frame(height: 200)
//                        .padding(.horizontal)
//                        .chartYScale(domain: 165...175)
//                        .chartXAxis {
//                            AxisMarks(values: .stride(by: .day, count: 7)) { _ in
//                                AxisGridLine()
//                                AxisTick()
//                                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
//                            }
//                        }
//                        .chartYAxis {
//                            AxisMarks { _ in
//                                AxisGridLine()
//                                AxisTick()
//                                AxisValueLabel()
//                            }
//                        }
//                    }
//                    .padding(.vertical)
//                }
//            }
//            .navigationTitle("Weight")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {}) {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Views/EmptyTabView.swift
//struct EmptyTabView: View {
//    let title: String
//    
//    var body: some View {
//        VStack {
//            Text(title)
//                .font(.title)
//                .fontWeight(.semibold)
//            
//            Text("Coming Soon")
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//    }
//}
//
//
//// MARK: - Preview
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
