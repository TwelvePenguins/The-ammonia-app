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
                TabView {
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
                            .font(.footnote)
                            HStack {
                                Image(systemName:"tray.and.arrow.down")
                                Text(daysBetween(start: meal.storedDate, end: Date.now))
                            }
                            .foregroundStyle(.gray)
                            .font(.footnote)
                            HStack(alignment: .center, spacing: 20) {
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("Expiry")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    Text(daysBetween(start: Date.now, end: meal.expiryDate))
                                        .bold()
                                }
                                .scaledToFill()
                                .frame(maxWidth: 80)
                                Divider()
                                    .scaledToFill()
                                    .frame(maxWidth: 2, maxHeight: 60)
                                  .background(Color.purple)
                                  .padding(.horizontal, 12)
                                VStack(alignment: .center) {
                                    Text("Planned for")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    Text(daysBetween(start: Date.now, end: meal.expiryDate))
                                        .bold()
                                }
                                .scaledToFill()
                                .frame(maxWidth: 80)
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
                    .padding(15)
                }
                .padding(25)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .navigationTitle(welcomeMsg)
            .toolbar {
                Button {
                   // refresh functionality
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .onAppear {
            upcomingMeals = meals.sorted { $0.expiryDate < $1.expiryDate }
            upcomingMeals = upcomingMeals.filter { $0.expiryDate > Date.now }
            index = Int(Double(upcomingMeals.count)*0.3.rounded(.up))
            upcomingMeals = Array(upcomingMeals[..<index])
        }
    }
}

