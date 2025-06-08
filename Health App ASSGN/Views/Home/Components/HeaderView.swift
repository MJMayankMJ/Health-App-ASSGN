//
//  HeaderView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Your GLP-1 Journey")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Track your shots, stay on course")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    HeaderView()
}
