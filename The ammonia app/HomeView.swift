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
            VStack {
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
                                    .background(Color("HighlightPurple"))
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
                            HStack {
                                Button {
                                    meal.isConsumed.toggle()
                                } label: {
                                    HStack(alignment: .center) {
                                        VStack(alignment: .center, spacing: 2) {
                                            Text("Mark as")
                                                .foregroundStyle(.secondary)
                                                .font(.subheadline)
                                            Text("Consumed")
                                                .fontWeight(.heavy)
                                                .foregroundStyle(.primary)
                                                .font(.headline)
                                        }
                                        Image(systemName: meal.isConsumed ? "checkmark.square" : "square")
                                    }
                                    .padding(15)
                                    .foregroundStyle(.white)
                                    .frame(height: 50)
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .background(.accent)
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal, 10)
                                NavigationLink {
                                    MealDetailView(meal: $meal)
                                } label: {
                                    HStack(alignment: .center) {
                                        VStack(alignment: .center, spacing: 2) {
                                            Text("More")
                                                .foregroundStyle(.secondary)
                                                .font(.subheadline)
                                            Text("Details")
                                                .fontWeight(.heavy)
                                                .foregroundStyle(.primary)
                                                .font(.headline)
                                        }
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding(15)
                                    .foregroundStyle(.white)
                                    .frame(height: 50)
                                    .scaledToFit()
                                    .background(.accent)
                                    .cornerRadius(10)
                                }
                                .padding(.trailing, 10)
                            }
                            .padding(.horizontal, -15)
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.accent, lineWidth: 3)
                            .padding(3)
                    )
                }
                VStack(alignment: .leading) {
                    Group {
                        Text("Three ")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(.accent) +
                        Text("meals are expiring ")
                            .font(.title2) +
                        Text("next Sunday.")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(.accent)
                    }
                    Text("Plan ahead if you can't finish in one day!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    //Chart
                }
                .padding(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.accent, lineWidth: 3)
                )
            }
            .padding(18)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
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

