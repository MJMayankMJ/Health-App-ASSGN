//
//  TimeButton.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct TimeButton: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.black : Color.clear)
            .cornerRadius(20)
    }
}


struct TimeButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TimeButton(title: "Today", isSelected: true)
            TimeButton(title: "Since last shot", isSelected: false)
            TimeButton(title: "Weekly", isSelected: false)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
