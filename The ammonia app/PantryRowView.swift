//
//  PantryRowView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 29/4/25.
//

import SwiftUI

struct PantryRowView: View {
    
    @State var idx: Int
    @Binding var meals: [Meal]
    
    var body: some View {
        NavigationLink {
            MealDetailView(meals: meals, meal: $meals[idx])
        } label: {
            if meals[idx].isConsumed == false {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(meals[idx].name)
                            .bold()
                            .font(.headline)
                        Text(daysBetween(start: Date.now,
                                         end: meals[idx].expiryDate,
                                         expiry: true))
                        .foregroundColor(
                            Color(findAttribute(
                                status: meals[idx].status,
                                find: "Colour")
                            )
                        )
                        .font(.caption)
                    }
                    Spacer()
                    Image(systemName: findAttribute(
                        status: meals[idx].status,
                        find: "SF")
                    )
                    .foregroundColor(
                        Color(findAttribute(
                            status: meals[idx].status,
                            find: "Colour")
                        )
                    )
                }
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text(meals[idx].name)
                        .bold()
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Stored \(meals[idx].storedDate, style: .date)")
                }
            }
        }
    }
}
