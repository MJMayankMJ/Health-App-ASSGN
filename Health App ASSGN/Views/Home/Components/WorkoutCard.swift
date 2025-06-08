//
//  WorkoutCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

struct WorkoutCard: View {
    let data: WorkoutData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: data.unit == "min" ? "camera.fill" : "figure.run")
                    .foregroundColor(data.unit == "min" ? .gray : .purple)
                Text("Workout")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text("\(data.value) \(data.unit)")
                .font(.system(size: 24, weight: .bold))
            
            Text(data.goal)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.4), radius: 2, x: 0, y: 1)
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WorkoutCard(data: WorkoutData(
                value: "30",
                unit: "min",
                goal: "Goal 45 min"
            ))
            .previewDisplayName("Minutes Format")
            
            WorkoutCard(data: WorkoutData(
                value: "5",
                unit: "sessions",
                goal: "Goal 6 sessions"
            ))
            .previewDisplayName("Sessions Format")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
