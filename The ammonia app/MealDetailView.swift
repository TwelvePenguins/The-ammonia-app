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
    
    @State var isDeleteAlertShown: Bool = false
    @State var isPopoverPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack { // Stack of the view
                Divider()
                    .frame(height: 3)
                    .padding(.bottom, 15)
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
                Spacer()
                VStack(alignment: .center) {
                    if meal.temperature == .normal && meal.humidity == .normal {
                        Text("No anomalies detected.")
                            .foregroundStyle(.secondary)
                        Button {
                            isPopoverPresented = true
                        } label: {
                            Text("What's that?")
                                .foregroundStyle(.secondary)
                                .foregroundColor(Color.accent)
                        }
                        .popover(isPresented: $isPopoverPresented,
                                 attachmentAnchor: .point(.center),
                                 arrowEdge: .bottom
                        ){
                            VStack(alignment: .center, spacing: 10) {
                                Image(systemName: "exclamationmark.circle")
                                    .font(.title2)
                                    .foregroundColor(Color.orange)
                                Text("Anomalies are flagged if the temperature and humidity sensors detects a stark shift from the usual environmental readings.")
                                    .multilineTextAlignment(.center)
                                Text("Please manually check the storage conditions of your meal.")
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 300, height: 200)
                            .padding(5)
                            .presentationCompactAdaptation(.popover)
                        }
                        
                    } else {
                        Text("Anomaly Detected.")
                            .bold()
                        if meal.temperature != .normal {
                            HStack(alignment: .center) {
                                Image(systemName: "thermometer")
                                Text(meal.temperature.rawValue)
                            }
                            .foregroundStyle(.secondary)
                        }
                        if meal.humidity != .normal {
                            HStack(alignment: .center) {
                                Image(systemName: "humidity")
                                Text(meal.humidity.rawValue)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
                Button {
                    meal.isConsumed = true
                    dismiss()
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
            .padding([.leading, .trailing], 20)
            .navigationTitle(meal.name)
            .toolbar {
                Button {
                    isDeleteAlertShown = true
                } label: {
                    Image(systemName: "trash")
                }
            }
            .alert("Are you sure you want to delete this meal?", isPresented: $isDeleteAlertShown, actions: {
                Button(role: .cancel) {
                    // Do Nothing
                } label: {
                    Text("Cancel")
                }
                Button(role: .destructive) {
                    let idxToRemove = mealManager.meals.firstIndex { $0.id == meal.id }
                    withAnimation(.snappy(duration: 0.2)) {
                        mealManager.meals.remove(at: idxToRemove!)
                    }
                    dismiss()
                } label: {
                    Text("Delete")
                }
            }, message: {
                Text("This action cannot be undone.")
            })
        }
    }
}
