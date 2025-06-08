//
//  WeightCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

struct WeightCard: View {
    let data: WeightData
    @EnvironmentObject var viewModel: HealthViewModel
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            // Show the weight entry sheet
            viewModel.showingWeightEntry = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "scalemass.fill")
                        .foregroundColor(.gray)
                    Text("Weight")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Spacer()
                    
                    // Add a subtle plus icon to indicate it's interactive
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.system(size: 16))
                }
                
                if let changeAmount = data.changeAmount {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Image(systemName: data.isDecrease ? "arrow.down" : "arrow.up")
                            .foregroundColor(data.isDecrease ? .green : .red)
                            .font(.system(size: 12))
                        Text("\(data.value) lbs")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                    }
                } else {
                    Text(data.value)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Text(data.goal)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.15), radius: 4, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct WeightCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeightCard(data: WeightData(
                value: "—",
                changeAmount: nil,
                isDecrease: false,
                goal: "Goal 100 lbs"
            ))
            .previewDisplayName("No Data")
            
            WeightCard(data: WeightData(
                value: "3",
                changeAmount: -3.0,
                isDecrease: true,
                goal: "Since last shot"
            ))
            .previewDisplayName("With Change")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
