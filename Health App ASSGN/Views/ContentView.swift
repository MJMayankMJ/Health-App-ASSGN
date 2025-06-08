//
//  ContentView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HealthViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .environmentObject(viewModel)
            
            EmptyTabView(title: "Progress")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
            
            EmptyTabView(title: "Calendar")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            EmptyTabView(title: "Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
