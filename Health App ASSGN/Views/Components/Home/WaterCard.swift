//
//  WaterCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct WaterCard: View {
    let intake: Int
    
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
            
            Text("\(Int(intake)) ml/day")
                .font(.system(size: 20, weight: .bold))
            
            Text("Goal: 3000 ml/day")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct WaterCard_Previews: PreviewProvider {
    static var previews: some View {
        WaterCard(intake: 2700)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
