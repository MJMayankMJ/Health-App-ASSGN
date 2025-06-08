//
//  WeightCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct WeightCard: View {
    let weight: Double
    let change: Double
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "scalemass.fill")
                    .foregroundColor(.gray)
                Text("Weight")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text(String(format: "%.1f lbs", weight))
                .font(.system(size: 24, weight: .bold))
            
            HStack {
                Text(String(format: "%+.1f lbs", change))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(change < 0 ? .green : .red)
                
                Spacer()
                
                Text("Since last shot")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        .onTapGesture {
            action()
        }
    }
}

struct WeightCard_Previews: PreviewProvider {
    static var previews: some View {
        WeightCard(weight: 170.0, change: -3.0) {
            print("Weight card tapped")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
