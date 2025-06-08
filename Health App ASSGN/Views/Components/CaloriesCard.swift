//
//  CaloriesCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct CaloriesCard: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text(String(format: "%.1f kcal", value))
                .font(.system(size: 18, weight: .bold))
            
            Text("Last 24 hrs")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct CaloriesCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CaloriesCard(title: "Calories Burnt", value: 2034.2, color: .orange)
            CaloriesCard(title: "Calories Consumed", value: 2034.2, color: .gray)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
