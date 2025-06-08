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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.black : Color.clear)
                .cornerRadius(20)
                .overlay(Capsule().stroke(isSelected ? Color.clear : Color(.systemGray4), lineWidth: 1))
        }
    }
}


struct TimeButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TimeButton(title: "Today", isSelected: true, action: {})
            TimeButton(title: "Since last shot", isSelected: false, action: {})
            TimeButton(title: "Weekly", isSelected: false, action: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
