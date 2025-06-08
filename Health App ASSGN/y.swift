//
//  y.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/8/25.
//

//import SwiftUI
//
//// MARK: - WheelPicker View
//
//struct WheelPicker: View {
//    // MARK: - Properties
//    
//    /// Configuration for the wheel picker.
//    var config: Config
//    /// Binding to the selected value.
//    @Binding var value: CGFloat
//    
//    /// State to track if the view has been loaded.
//    @State private var isLoaded: Bool = false
//    
//    // MARK: - Body
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let size = geometry.size
//            let horizontalPadding = size.width / 2
//            
//            ScrollView(.horizontal) {
//                HStack(spacing: config.spacing) {
//                    let totalSteps = config.steps * config.count
//                    
//                    ForEach(0...totalSteps, id: \.self) { index in
//                        let remainder = index % config.steps
//                        
//                        Divider()
//                            .background(remainder == 0 ? Color.primary.opacity(0.5) : .gray.opacity(0.5))
//                            .frame(width: 0, height: remainder == 0 ? 20 : 10, alignment: .center)
//                            .frame(maxHeight: 20, alignment: .bottom)
//                            .overlay(alignment: .bottom) {
//                                if remainder == 0 && config.showsText {
//                                    Text("\((index / config.steps) * config.multiplier)")
//                                        .font(.caption)
//                                        .fontWeight(.semibold)
//                                        .textScale(.secondary)
//                                        .fixedSize()
//                                        .offset(y: 20)
//                                }
//                            }
//                    }
//                }
//                .frame(height: size.height)
//                .scrollTargetLayout()
//            }
//            .scrollIndicators(.hidden)
//            .scrollTargetBehavior(.viewAligned)
//            .scrollPosition(id: .init(get: {
//                // Calculates the scroll position based on the current value.
//                let position: Int? = isLoaded ? (Int(value) / config.multiplier) * config.steps : nil
//                return position
//            }, set: { newValue in
//                // Updates the value when the scroll position changes.
//                if let newValue {
//                    value = (CGFloat(newValue) / CGFloat(config.steps)) * CGFloat(config.multiplier)
//                }
//            }))
//            .overlay(alignment: .center) {
//                // The center indicator of the picker.
//                 Rectangle()
//                    .frame(width: 2, height: 40)
//                    .foregroundColor(.green)
//            }
//            .safeAreaPadding(.horizontal, horizontalPadding)
//            .onAppear {
//                if !isLoaded {
//                    isLoaded = true
//                }
//            }
//        }
//    }
//    
//    // MARK: - Configuration Struct
//    
//    struct Config: Equatable {
//        var count: Int
//        var steps: Int = 10
//        var spacing: CGFloat = 12
//        var multiplier: Int = 10
//        var showsText: Bool = true
//    }
//}
//
//
//// MARK: - AddWeightView
//
//struct WeightEntryView: View {
//    // MARK: - Properties
//    @State private var weight: CGFloat = 170
//    
//    // MARK: - Body
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // Background color for the whole screen
//                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
//                
//                VStack(spacing: 25) {
//                    
//                    // MARK: Top Icon
//                    ZStack(alignment: .center) {
//                         RoundedRectangle(cornerRadius: 15)
//                             .fill(Color(.secondarySystemGroupedBackground))
//                             .frame(width: 100, height: 100)
//                        
//                         Image(systemName: "scalemass.fill")
//                             .font(.system(size: 50))
//                             .foregroundColor(.primary)
//
//                         Image(systemName: "plus.viewfinder")
//                            .font(.system(size: 24, weight: .semibold))
//                            .foregroundColor(.primary)
//                            .padding(4)
//                            .background(Color(.systemGroupedBackground).clipShape(Circle()))
//                            .offset(x: 5, y: 5)
//                    }
//                    
//                    // MARK: Weight Picker Card
//                    VStack(spacing: 15) {
//                        Text("\(Int(weight))")
//                            .font(.system(size: 80, weight: .bold))
//                            .contentTransition(.numericText(value: weight))
//                            .animation(.snappy, value: weight)
//
//                        WheelPicker(
//                            config: .init(count: 300, steps: 10, spacing: 12, multiplier: 1, showsText: true),
//                            value: $weight
//                        )
//                        .frame(height: 60)
//                        
//                        Text("lb")
//                            .fontWeight(.semibold)
//                            .foregroundStyle(.secondary)
//                        
//                    }
//                    .padding(.vertical)
//                    .background(Color(.secondarySystemGroupedBackground).clipShape(RoundedRectangle(cornerRadius: 20)))
//
//                    // MARK: Body Fat Percentage Row
//                    HStack {
//                        Text("Body Fat Percentage")
//                            .fontWeight(.medium)
//                        Spacer()
//                        Text("--")
//                            .foregroundStyle(.secondary)
//                    }
//                    .padding()
//                    .background(Color(.secondarySystemGroupedBackground).clipShape(RoundedRectangle(cornerRadius: 20)))
//
//                    // MARK: Info Text
//                    Text("Progress isn't just numbers —\nsnap a photo to log your journey")
//                        .font(.footnote)
//                        .foregroundStyle(.secondary)
//                        .multilineTextAlignment(.center)
//
//                    Spacer()
//                    
//                    // MARK: Record Button
//                    Button(action: {}) {
//                        Text("Record")
//                            .fontWeight(.semibold)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.gray.opacity(0.8))
//                            .foregroundColor(.white)
//                            .cornerRadius(15)
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("Add Weight")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {}) {
//                        Image(systemName: "xmark")
//                            .foregroundColor(.primary)
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//
//#Preview {
//    WeightEntryView()
//}
