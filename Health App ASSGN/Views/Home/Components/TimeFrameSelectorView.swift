//
//  TimeFrameSelectorView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

import SwiftUI

struct TimeFrameSelectorView: View {
    @Binding var selectedTimeFrame: HomeView.TimeFrame
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(HomeView.TimeFrame.allCases, id: \.self) { timeFrame in
                TimeButton(
                    title: timeFrame.title,
                    isSelected: selectedTimeFrame == timeFrame
                ) {
                    selectedTimeFrame = timeFrame
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}


