//
//  NextShotCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct NextShotCard: View {
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                Text("Time to Next Shot")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text(time)
                .font(.system(size: 18, weight: .bold))
            
            Text("Schedule")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct NextShotCard_Previews: PreviewProvider {
    static var previews: some View {
        NextShotCard(time: "Today")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
