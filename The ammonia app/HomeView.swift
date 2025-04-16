//
//  HomeView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var meals: [Meal]
    @State var upcomingMeals: [Meal] = []
    @State var welcomeMsg: String = "Time to Feast!"
    
    var body: some View {
        NavigationView {
            HStack {
                TabView {
                    
                }
            }
        }
        .navigationTitle(welcomeMsg)
        .onAppear {
            upcomingMeals = meals.sorted {$0.expiryDate < $1.expiryDate}
            print(upcomingMeals)
        }
    }
}

