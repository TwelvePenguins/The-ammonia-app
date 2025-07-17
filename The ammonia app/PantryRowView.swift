//
//  PantryRowView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 29/4/25.
//

import SwiftUI

struct PantryRowView: View {
    
    @Binding var meal: Meal
    @Bindable var mealManager: MealManager
    
    var body: some View {
        if meal.isConsumed == false {
            NavigationLink {
                MealDetailView(mealManager: mealManager, meal: $meal)
            } label: {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(meal.name)
                            .bold()
                            .font(.headline)
                        Text(daysBetween(start: Date.now,
                                         end: meal.expiryDate,
                                         expiry: true))
                        .foregroundColor(
                            Color(findAttribute(
                                status: meal.status,
                                find: "Colour")
                            )
                        )
                        .font(.caption)
                    }
                    Spacer()
                    Image(systemName: findAttribute(
                        status: meal.status,
                        find: "SF")
                    )
                    .foregroundColor(
                        Color(findAttribute(
                            status: meal.status,
                            find: "Colour")
                        )
                    )
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 3) {
                Text(meal.name)
                    .bold()
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text("Stored \(meal.storedDate, style: .date)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}
