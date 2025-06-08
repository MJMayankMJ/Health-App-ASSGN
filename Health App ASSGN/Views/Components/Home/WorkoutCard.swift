//
//  WorkoutCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct WorkoutCard: View {
    let sessions: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "figure.run")
                    .foregroundColor(.purple)
                Text("Workout")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text("\(sessions) sessions")
                .font(.system(size: 18, weight: .bold))
            
            Text("This week")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCard(sessions: 3)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
