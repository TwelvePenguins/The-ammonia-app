//
//  ContentView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var meals: [Meal] = [
        Meal(name: "Sandwiches", storedDate: Date(timeInterval: -23487, since: Date.now), plannedDate: Date(timeInterval: 3698, since: Date.now), expiryDate: Date(timeInterval: 28329, since: Date.now)), // Should be safe
        Meal(name: "Pizza", storedDate: Date(timeInterval: -2837, since: Date.now), plannedDate: Date(timeInterval: 12937, since: Date.now), expiryDate: Date(timeInterval: 1283, since: Date.now)), // Should be attention required
        Meal(name: "Noodles", storedDate: Date(timeInterval: -123981, since: Date.now), plannedDate: Date(timeInterval: 123673, since: Date.now), expiryDate: Date(timeInterval: -301238, since: Date.now)), // Should be expired
    ]
    
    var body: some View {
        TabView {
            HomeView(meals: $meals)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            PantryView(meals: $meals)
                .tabItem {
                    Label("Pantry List", systemImage: "list.bullet")
                }
            }
        }
    }



#Preview {
    ContentView()
}
