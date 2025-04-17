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
    @State var index: Int = 0
    
    var body: some View {
        NavigationView {
            HStack {
                TabView{
                    ForEach($upcomingMeals, id: \.self) { $meal in
                        VStack(alignment: .leading) {
                            Text(meal.name)
                                .font(.title)
                                .bold()
                            HStack {
                                Image(systemName: findAttribute(status: meal.status, find: "SF"))
                                Text(meal.status.rawValue)
                            }
                            .foregroundColor(Color(findAttribute(status: meal.status, find: "Colour")))
                            HStack {
                                Image(systemName:"tray.and.arrow.down")
                                Text("\(daysBetween(start: meal.storedDate, end: Date.now)) ago")
                            }
                            .foregroundStyle(.gray)
                            HStack(alignment: .center, spacing: 20) {
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("Expires in")
                                        .foregroundStyle(.secondary)
                                    Text(daysBetween(start: Date.now, end: meal.expiryDate))
                                        .bold()
                                }
                                Divider()
                                  .frame(width: 2, height: 40)
                                  .background(Color.purple)
//                                  .frame(maxHight: .infinity)
                                  .padding(.horizontal, 8)
                                VStack(alignment: .center) {
                                    Text("Planned for")
                                        .foregroundStyle(.secondary)
                                    Text(daysBetween(start: Date.now, end: meal.expiryDate)) //TODO: add ago/later/today functionality
                                        .bold()
                                }
                                Spacer()
                            }
                            .multilineTextAlignment(.center)
                        }
                        .padding(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.purple, lineWidth: 3)
                        )
                    }
                }
                .padding(25)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
        }
        .navigationTitle(welcomeMsg)
        .onAppear {
            upcomingMeals = meals.sorted { $0.expiryDate < $1.expiryDate }
            upcomingMeals = upcomingMeals.filter { $0.expiryDate > Date.now }
            index = Int(Double(upcomingMeals.count)*0.3.rounded(.up))
            upcomingMeals = Array(upcomingMeals[..<index])
        }
    }
}

