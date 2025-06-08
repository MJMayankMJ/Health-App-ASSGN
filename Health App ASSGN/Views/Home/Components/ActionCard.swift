//
//  ActionCard.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

struct ActionCard: View {
    let data: ActionData
    let isCompact: Bool
    
    init(data: ActionData, isCompact: Bool = false) {
        self.data = data
        self.isCompact = isCompact
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if data.isGradient {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.white)
                    Text(data.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                } else if isCompact {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.blue)
                    Text(data.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "heart.text.square.fill")
                        .foregroundColor(.orange)
                    Text(data.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if !data.buttonText.isEmpty {
                    if data.isGradient {
                        Button(action: data.action) {
                            HStack {
                                Text(data.buttonText)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.blue)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    } else {
                        Button(data.buttonText, action: data.action)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            
            if let subtitle = data.subtitle {
                if isCompact {
                    Text(subtitle)
                        .font(.system(size: 18, weight: .bold))
                } else {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(data.isGradient ? .white.opacity(0.8) : .gray)
                        .italic()
                }
            }
            
            if let description = data.description {
                if isCompact {
                    Text(description)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                } else {
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(data.isGradient ? .white.opacity(0.8) : .gray)
                        .italic()
                }
            }
            
            // Health icons for gradient cards
            if data.isGradient, let icons = data.icons {
                HStack(spacing: 8) {
                    ForEach(icons, id: \.self) { iconName in
                        Image(systemName: iconName)
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 16))
                    }
                }
            }
        }
        .padding()
        .background(
            data.isGradient ?
            AnyView(LinearGradient(
                colors: [data.backgroundColor, data.backgroundColor.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )) :
            AnyView(data.backgroundColor)
        )
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.4), radius: 2, x: 0, y: 1)
    }
}

struct ActionCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActionCard(data: ActionData(
                title: "Daily Check-in",
                subtitle: "Keep the streak going!",
                description: "Log today's data",
                buttonText: "Add Today's Data",
                isGradient: true,
                backgroundColor: .blue,
                icons: ["bubbles.and.sparkles.fill", "dumbbell.fill", "drop.fill"],
                action: {}
            ))
            .previewDisplayName("Gradient Style")
            
            ActionCard(data: ActionData(
                title: "Any side Effects today?",
                subtitle: nil,
                description: "Let us know how you're feeling — it helps track patterns and feel more in control.",
                buttonText: "Log Side Effects",
                isGradient: false,
                backgroundColor: Color(UIColor.systemGray6),
                icons: nil,
                action: {}
            ))
            .previewDisplayName("Regular Style")
            
            ActionCard(data: ActionData(
                title: "Time to Next Shot",
                subtitle: "Today",
                description: "On 8th May 2025",
                buttonText: "",
                isGradient: false,
                backgroundColor: .white,
                icons: nil,
                action: {}
            ), isCompact: true)
            .previewDisplayName("Compact Style")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
