//
//  MealDetailView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 28/4/25.
//

import SwiftUI

struct MealDetailView: View {
    
    @Binding var meal: Meal
    
    var body: some View {
        NavigationView {
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
                            .background(Color.purple)
                            .padding(.horizontal, 8)
                        VStack(alignment: .center) {
                            Text("Planned for")
                                .foregroundStyle(.secondary)
                            Text(daysBetween(start: Date.now, end: meal.expiryDate))
                                .bold()
                        }
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                }
                .padding(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.purple, lineWidth: 3)
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
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                // Graph here
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
                }
                .padding()
            }
            .padding(15)
        }
        .navigationTitle(meal.name)
        .toolbar {
            Button {
                // Delete Function
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}
