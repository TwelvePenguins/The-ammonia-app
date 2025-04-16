//
//  ContentView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var meals: [Meal] = [
        Meal(name: "Sandwiches", storedDate: Date.distantPast, plannedDate: Date(timeInterval: 31415, since: Date.now), expiryDate: Date(timeInterval: 301238, since: Date.now)),
        Meal(name: "Pizza", storedDate: Date.distantPast, plannedDate: Date(timeInterval: 123673, since: Date.now), expiryDate: Date(timeInterval: 301238, since: Date.now)),
        Meal(name: "Noodles", storedDate: Date.distantPast, plannedDate: Date(timeInterval: 123673, since: Date.now), expiryDate: Date(timeInterval: -301238, since: Date.now)),
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

func findAttribute(status: MealStatus, find: String) -> String {
    if find == "SF" {
        if status == .attentionRequired {
            return "exclamationmark.triangle"
        } else if status == .expired {
            return "xmark.seal"
        } else {
            return "checkmark.seal"
        }
    } else if find == "Colour" {
        if status == .attentionRequired {
            return "Orange"
        } else if status == .expired {
            return "Red"
        } else {
            return "Green"
        }
    } else {
        return ""
    }
}

#Preview {
    ContentView()
}
