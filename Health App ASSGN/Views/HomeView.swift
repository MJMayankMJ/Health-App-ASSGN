//
//  HomeView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HealthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Your GLP-1 Journey")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("Track your goals, step by step")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    // Date selector
                    HStack {
                        ForEach(11...17, id: \.self) { day in
                            VStack {
                                Text("\(day)")
                                    .font(.caption)
                                    .foregroundColor(day == 17 ? .white : .gray)
                                
                                Circle()
                                    .fill(day == 17 ? Color.blue : Color.clear)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Text("\(day)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(day == 17 ? .white : .primary)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Time period selector
                    HStack {
                        TimeButton(title: "Today", isSelected: true)
                        TimeButton(title: "Since last shot", isSelected: false)
                        TimeButton(title: "Weekly", isSelected: false)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Daily Check-in Card
                    DailyCheckinCard()
                        .padding(.horizontal)
                    
                    // Health Metrics Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        WeightCard(
                            weight: viewModel.healthData.currentWeight,
                            change: viewModel.healthData.weightChange
                        ) {
                            viewModel.showingWeightEntry = true
                        }
                        
                        WaterCard(intake: viewModel.healthData.waterIntake)
                        
                        CaloriesCard(
                            title: "Calories Burnt",
                            value: viewModel.healthData.caloriesBurnt,
                            color: .orange
                        )
                        
                        CaloriesCard(
                            title: "Calories Consumed",
                            value: viewModel.healthData.caloriesConsumed,
                            color: .gray
                        )
                        
                        WorkoutCard(sessions: viewModel.healthData.workoutSessions)
                        
                        NextShotCard(time: viewModel.healthData.nextShotTime)
                    }
                    .padding(.horizontal)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HealthViewModel())
    }
}
