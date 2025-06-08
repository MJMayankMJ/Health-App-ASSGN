//
//  DailyCheckinCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct DailyCheckinCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                    Text("Daily Check-in")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text("Keep the streak going!")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Log today's data")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button("Add Today's Data") {
                // Action for adding today's data
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white)
            .cornerRadius(12)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue, Color.blue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

struct DailyCheckinCard_Previews: PreviewProvider {
    static var previews: some View {
        DailyCheckinCard()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
