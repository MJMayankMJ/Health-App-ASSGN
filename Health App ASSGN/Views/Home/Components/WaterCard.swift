//
//  WaterCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

struct WaterCard: View {
    let data: WaterData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundColor(.blue)
                Text("Water")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text(String(format: "%.1f %@", data.value, data.unit))
                .font(.system(size: 24, weight: .bold))
            
            Text(data.goal)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.4), radius: 2, x: 0, y: 1)
    }
}

struct WaterCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WaterCard(data: WaterData(
                value: 124.5,
                unit: "ml",
                goal: "Goal 3.0 L"
            ))
            .previewDisplayName("Today Format")
            
            WaterCard(data: WaterData(
                value: 2700,
                unit: "ml/day",
                goal: "Goal 3000 ml/day"
            ))
            .previewDisplayName("Since Last Shot Format")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
