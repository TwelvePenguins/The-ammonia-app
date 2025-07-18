//
//  NewMealView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 18/7/25.
//

import SwiftUI

struct NewMealView: View {
    
    @Bindable var mealManager: MealManager
    @State var newMeal: Meal = Meal(name: "", storedDate: Date.now, plannedDate: Date.now, isAlertOn: false, expiryDate: dateFormatter.date(from: "23-07-2025")!, isConsumed: false)
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @State var showSaveAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Connection Status")) {
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "iphone.radiowaves.left.and.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                            Image(systemName: "ellipsis")
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("Green"))
                            Image(systemName: "ellipsis")
                            HStack(alignment: .center) {
                                Image("bluetooth")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                Text("SF Sensor 001")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.primary)
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.accent, lineWidth: 1.5)
                            )
                            Spacer()
                        }
                        .padding(20)
                        .foregroundColor(.accentColor)
                    }
                    Section(header: Text("Basic Information")) {
                        HStack {
                            Text("Meal Name")
                            TextField("Meal Name", text: $newMeal.name, prompt: Text("Eg. Lasagna"))
                                .multilineTextAlignment(.trailing)
                                .submitLabel(.done)
                                .focused($isTextFieldFocused)
                                .onSubmit {
                                    isTextFieldFocused = false
                                }
                        }
                        DatePicker("To Consume By", selection: $newMeal.plannedDate, in: Date.now..., displayedComponents: .date)
                        Toggle("Notification Reminders", isOn: $newMeal.isAlertOn)
                    }
                }
                Spacer()
                Button {
                    if newMeal.name == "" {
                        showSaveAlert = true
                    } else {
                        mealManager.meals.append(newMeal)
                        dismiss()
                    }
                } label: {
                    Text("Save")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                        .opacity(newMeal.name == "" ? 0.5: 1)
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                        .bold()
                }
//                .disabled(newMeal.name == "")
                .padding([.top, .leading, .trailing])
                .padding(.bottom, 10)
                Button(role: .cancel) {
                    newMeal = Meal(name: "", storedDate: Date.now, plannedDate: Date.now, isAlertOn: false, expiryDate: dateFormatter.date(from: "23-07-2025")!, isConsumed: false)
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.accent)
                }
                .padding(.bottom)
                .scrollDismissesKeyboard(.immediately)
            }
            .navigationTitle(newMeal.name == "" ? "New Meal" : "\(newMeal.name)")
            .alert("Please input a meal name.", isPresented: $showSaveAlert, actions: {
                Button {
                    showSaveAlert = false
                } label: {
                    Text("OK")
                }
            })
        }
        .interactiveDismissDisabled(newMeal.name != "")
    }
}
