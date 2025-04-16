//
//  HomeView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var meals: [Meal]
    @State var welcomeMsg: String = "Time to Feast!"
    @State var upcomingMeals: [Meal] = []
    
    var body: some View {
        NavigationView {
            HStack {
                ForEach($upcomingMeals, id: \.self) { $meal in
                    VStack(alignment: .leading, spacing: 15) {
                        Text(meal.name)
                            .font(.title)
                            .bold()
                        HStack {
                            Image(systemName: findAttribute(status: meal.status, find: "SF"))
                            Text(meal.status.rawValue)
                        }
                        .foregroundColor(Color(findAttribute(status: meal.status, find: "Colour")))
                    }
                    .padding(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.purple, lineWidth: 2)
                    )
                }
            }
        }
        .navigationTitle(welcomeMsg)
        .onAppear {
            meals = meals.sorted { $0.expiryDate < $1.expiryDate }
            upcomingMeals = Array(meals[..<2])
        }
    }
}

