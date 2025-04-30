//
//  ContentView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import SwiftUI
import Foundation

let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd-MM-yyyy"
    return df
}()

struct ContentView: View {
    
    @State var meals: [Meal] = [
        Meal(name: "Chicken Sandwiches", storedDate: Date.now, plannedDate: dateFormatter.date(from: "03-05-2025")!, expiryDate: dateFormatter.date(from: "07-05-2025")!), // Should be safe
        Meal(name: "Hawaiian Pizza", storedDate: Date.now, plannedDate: dateFormatter.date(from: "06-05-2025")!, expiryDate: dateFormatter.date(from: "02-05-2025")!), // Should be attention required
        Meal(name: "Beef Noodles", storedDate: Date.now, plannedDate: dateFormatter.date(from: "03-05-2025")!, expiryDate: dateFormatter.date(from: "28-04-2025")!), // Should be expired
        Meal(name: "Bak Kuh Teh", storedDate: dateFormatter.date(from: "28-04-2025")!, plannedDate: dateFormatter.date(from: "03-05-2025")!, expiryDate: dateFormatter.date(from: "29-04-2025")!), // Should be attention required
        Meal(name: "Chicken Stew", storedDate: dateFormatter.date(from: "29-04-2025")!, plannedDate: dateFormatter.date(from: "04-05-2025")!, expiryDate: dateFormatter.date(from: "05-05-2025")!), // Should be safe

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
        .onAppear{
            print(Date.now)
        }
    }
}
