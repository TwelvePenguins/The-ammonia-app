//
//  MealDetailView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 28/4/25.
//

import SwiftUI

struct MealDetailView: View {
    
    @Bindable var mealManager: MealManager // Here only for the deletion function - could figure out how to do just by the manager?
    @Binding var meal: Meal
    
    @State var chartData: [Ammonia] = [
        Ammonia(date: 12, count: 1.5, day: "Mon"),
        Ammonia(date: 13, count: 2.0, day: "Tue"),
        Ammonia(date: 14, count: 1.5, day: "Wed"),
        Ammonia(date: 15, count: 0.0, day: "Thu"),
        Ammonia(date: 16, count: 1.0, day: "Fri"),
        Ammonia(date: 17, count: 0.5, day: "Sat"),
        Ammonia(date: 18, count: 1.5, day: "Sun")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack { // Stack of the view
                    Divider()
                        .frame(height: 3)
                        .padding(.bottom, 15)
                    Spacer()
                    VStack(alignment: .center) { // Stack of the card
                        HStack {
                            Image(systemName: findAttribute(status: meal.status, find: "SF"))
                            Text(meal.status.rawValue)
                        }
                        .foregroundColor(Color(findAttribute(status: meal.status, find: "Colour")))
                        HStack(alignment: .center, spacing: 20) {
                            Spacer()
                            VStack(alignment: .center) {
                                Text("Expiry")
                                    .foregroundStyle(.secondary)
                                Text(daysBetween(start: Date.now, end: meal.expiryDate))
                                    .bold()
                            }
                            Divider()
                                .frame(width: 2, height: 40)
                                .background(Color.accent)
                                .padding(.horizontal, 8)
                            VStack(alignment: .center) {
                                Text("Planned for")
                                    .foregroundStyle(.secondary)
                                Text(daysBetween(start: Date.now, end: meal.plannedDate))
                                    .bold()
                            }
                            Spacer()
                        }
                        .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.accent, lineWidth: 3)
                    )
                    .animation(.easeIn(duration: 0.2), value: meal.status)
                    List {
                        HStack {
                            Text("Stored")
                            Spacer()
                            Text(meal.storedDate, style: .date)
                                .foregroundStyle(.secondary)
                                .font(.body)
                        }
                        DatePicker("Planned Date", selection: $meal.plannedDate, in: Date.now..., displayedComponents: .date)
                        Toggle("Notification Reminders", isOn: $meal.isAlertOn)
                    }
                    .padding(.vertical, 15)
                    .frame(height: 175)
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    VStack(alignment: .leading) {
                        Text("Ammonia over time")
                            .bold()
                            .font(.title2)
                        HStack(alignment: .bottom, spacing: 0) {
                            ForEach(chartData, id: \.self) { data in
                                ChartBarView(date: data.date, value: data.count, day: data.day)
                                if data.day != "Sun" {
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    Spacer()
                    Button {
                        meal.isConsumed = true
                    } label: {
                        Text("Mark as Consumed")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(.accent)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                            .bold()
                    }
                    .padding()
                }
                .padding(15)
            }
        }
        .navigationTitle(meal.name)
//        .toolbar {
//            Button {
//                if let mealIndex = meals.firstIndex(where: {
//                    $0.id == meal.id
//                }) {
//                    meals.remove(at: mealIndex)
//                }
//            } label: {
//                Image(systemName: "trash")
//            }
//        }
    }
}
