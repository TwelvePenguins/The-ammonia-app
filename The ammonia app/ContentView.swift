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
    
    var body: some View {
        TabView {
            HomeView(mealManager: mealManager)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            PantryView(mealManager: mealManager)
                .tabItem {
                    Label("Pantry List", systemImage: "list.bullet")
                }
        }
        .onAppear{
            print(Date.now)
        }
    }
}
