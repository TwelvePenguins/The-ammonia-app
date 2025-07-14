//
//  PantryRowView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 29/4/25.
//

import SwiftUI

struct PantryRowView: View {
    
    @State var idx: Int
    @Bindable var mealManager: MealManager
    
    var body: some View {
        NavigationLink {
            MealDetailView(mealManager: mealManager, meal: $mealManager.meals[idx])
        } label: {
            if mealManager.meals[idx].isConsumed == false {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(mealManager.meals[idx].name)
                            .bold()
                            .font(.headline)
                        Text(daysBetween(start: Date.now,
                                         end: mealManager.meals[idx].expiryDate,
                                         expiry: true))
                        .foregroundColor(
                            Color(findAttribute(
                                status: mealManager.meals[idx].status,
                                find: "Colour")
                            )
                        )
                        .font(.caption)
                    }
                    Spacer()
                    Image(systemName: findAttribute(
                        status: mealManager.meals[idx].status,
                        find: "SF")
                    )
                    .foregroundColor(
                        Color(findAttribute(
                            status: mealManager.meals[idx].status,
                            find: "Colour")
                        )
                    )
                }
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text(mealManager.meals[idx].name)
                        .bold()
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Stored \(mealManager.meals[idx].storedDate, style: .date)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
}
