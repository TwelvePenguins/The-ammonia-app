//
//  HomeView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import SwiftUI

struct HomeView: View {
    
    @Bindable var mealManager: MealManager
    
    @State var welcomeMsg: String = "Time to Feast!"
    @State var index: Int = 0
    @State private var isAnimating: Bool = false
    
    @State var chartData: [Ammonia] = [
        Ammonia(date: 14, count: 0.0, day: "Mon"),
        Ammonia(date: 15, count: 1.5, day: "Tue"),
        Ammonia(date: 16, count: 3.0, day: "Wed"),
        Ammonia(date: 17, count: 0.0, day: "Thu"),
        Ammonia(date: 18, count: 0.0, day: "Fri"),
        Ammonia(date: 19, count: 1.5, day: "Sat"),
        Ammonia(date: 20, count: 0.0, day: "Sun")
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("UPCOMING MEALS")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                    .padding(.leading, 20)
                TabView {
                    if !mealManager.upcomingMeals.isEmpty {
                        ForEach(mealManager.upcomingMeals, id: \.self) { meal in
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    Text(meal.name)
                                        .font(.title)
                                        .bold()
                                    HStack {
                                        Image(systemName: findAttribute(status: meal.status, find: "SF"))
                                        Text(meal.status.rawValue)
                                    }
                                    .foregroundColor(Color(findAttribute(status: meal.status, find: "Colour")))
                                    .font(.callout)
                                    HStack {
                                        Image(systemName:"tray.and.arrow.down")
                                        Text(daysBetween(start: Date.now, end: meal.storedDate))
                                    }
                                    .foregroundStyle(.gray)
                                    .font(.callout)
                                }
                                .padding(.horizontal, 15)
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
                                        Text(daysBetween(start: Date.now, end: meal.plannedDate))
                                            .bold()
                                    }
                                    .scaledToFill()
                                    .frame(maxWidth: 80)
                                    Spacer()
                                }
                                .multilineTextAlignment(.center)
                                HStack {
                                    Button {
                                        guard meal.isConsumed == false else { return }
                                        mealManager.meals[mealManager.meals.firstIndex(of: meal)!].isConsumed = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            isAnimating = true
                                            print("isAnimating true")
                                        }
                                        isAnimating = false
                                        print("isAnimating false")
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
                                        .shadow(radius: 5, y: 3)
                                    }
                                    .padding(.horizontal, 10)
                                    NavigationLink {
                                        if !isAnimating {
                                            MealDetailView(mealManager: mealManager, meal: $mealManager.meals[mealManager.meals.firstIndex(of: meal)!])
                                        }
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
                                        .shadow(radius: 5, y: 3)
                                    }
                                    .onTapGesture {
                                        guard isAnimating else {
                                            return print("gesture mid animation")
                                        }
                                    }
                                    .padding(.trailing, 10)
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                        .padding(.vertical, 30)
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.accent, lineWidth: 3)
                                .padding(3)
                        )
                    } else if mealManager.upcomingMeals.isEmpty {
                        Text("No upcoming meals")
                            .foregroundStyle(.secondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.accent, lineWidth: 3)
                                    .padding(3)
                                    .frame(width: 366, height: 260)
                            )
                    }
                }
                .padding([.bottom, .top], -19)
                .offset(y: -15)
                
                VStack(alignment: .leading) {
                    Group {
                        Text("Two ")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(.accent) +
                        Text("meals are expiring ")
                            .fontWeight(.medium)
                            .font(.title2) +
                        Text("this Wednesday.")
                            .bold()
                            .font(.title2)
                            .foregroundStyle(.accent)
                    }
                    Text("Plan ahead if you can't finish in one day!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    // Hard-coded chart
                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(chartData, id: \.self) { data in
                            ChartBarView(date: data.date, value: data.count, day: data.day)
                            if data.day != "Sun" {
                                Spacer()
                            }
                        }
                    }
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
        }
    }
}
