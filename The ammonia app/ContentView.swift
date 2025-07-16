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
    
    @State var mealManager = MealManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(mealManager: mealManager)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
                
            PantryView(mealManager: mealManager)
                .tabItem {
                    Label("Pantry", systemImage: "list.bullet")
                }
                .tag(1)
                
            AnalyticsView(mealManager: mealManager)
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
                .tag(2)
                
            NotificationView(mealManager: mealManager)
                .tabItem {
                    Label {
                        Text("Notifications")
                    } icon: {
                        if mealManager.getUnreadNotificationsCount() > 0 {
                            Image(systemName: "bell.badge")
                        } else {
                            Image(systemName: "bell")
                        }
                    }
                }
                .tag(3)
        }
        .onAppear {
            mealManager.generateNotifications()
            mealManager.updateAnalytics()
        }
    }
}
