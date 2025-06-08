//
//  CaloriesCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

enum CaloriesType {
    case consumed, burnt
    
    var icon: String {
        switch self {
        case .consumed: return "checkmark.circle.fill"
        case .burnt: return "flame.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .consumed: return .gray
        case .burnt: return .orange
        }
    }
    
    var title: String {
        switch self {
        case .consumed: return "Calories"
        case .burnt: return "Calories Burnt"
        }
    }
}

struct CaloriesCard: View {
    let data: CaloriesData
    let type: CaloriesType
    
    init(data: CaloriesData, type: CaloriesType = .consumed) {
        self.data = data
        self.type = type
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(type.color)
                Text(type.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text(String(format: "%.1f %@", data.value, data.unit))
                .font(.system(size: 24, weight: .bold))
            
            Text(data.goal)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            // Breakdown section (only for consumed calories)
            if let breakdown = data.breakdown {
                Text("Breakdown")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.top, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(breakdown.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: getIconName(for: breakdown[index].0))
                                    .foregroundColor(breakdown[index].2)
                                    .font(.system(size: 12))
                                Text(breakdown[index].0)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(breakdown[index].1)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            // Progress bar
                            GeometryReader { geometry in
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(breakdown[index].2)
                                        .frame(width: getProgressWidth(for: breakdown[index].1, totalWidth: geometry.size.width))
                                        .frame(height: 4)
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 4)
                                }
                            }
                            .frame(height: 4)
                            .cornerRadius(2)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.4), radius: 2, x: 0, y: 1)
    }
    
    private func getIconName(for nutrient: String) -> String {
        switch nutrient {
        case "Protein": return "dumbbell.fill"
        case "Carbs": return "leaf.fill"
        case "Fats": return "drop.fill"
        default: return "circle.fill"
        }
    }
    
    private func getProgressWidth(for value: String, totalWidth: CGFloat) -> CGFloat {
        let components = value.split(separator: "/")
        guard components.count == 2,
              let current = Double(components[0].replacingOccurrences(of: "g", with: "")),
              let total = Double(components[1].replacingOccurrences(of: "g", with: "")) else {
            return totalWidth * 0.3
        }
        
        let percentage = min(current / total, 1.0)
        return totalWidth * percentage
    }
}

struct CaloriesCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CaloriesCard(data: CaloriesData(
                value: 2034.6,
                unit: "kcal",
                goal: "Goal 2400 kcal",
                breakdown: [
                    ("Protein", "30g/100g", .blue),
                    ("Carbs", "100g/250g", .orange),
                    ("Fats", "30g/70g", .red)
                ]
            ))
            .previewDisplayName("With Breakdown")
            
            CaloriesCard(data: CaloriesData(
                value: 1000,
                unit: "kcal",
                goal: "Goal 1300 kcal",
                breakdown: nil
            ), type: .burnt)
            .previewDisplayName("Burnt Calories")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
