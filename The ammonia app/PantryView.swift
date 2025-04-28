//
//  PantryView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import SwiftUI

struct PantryView: View {
    
    @Binding var meals: [Meal]
    @State private var searchKey: String = ""
    
    private var filteredIndices: [Int] {
        guard !searchKey.isEmpty else {
            return Array(meals.indices)
        }
        return meals.indices.filter { meals[$0].name.localizedCaseInsensitiveContains(searchKey) }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredIndices, id: \.self) { idx in
                    NavigationLink {
                        MealDetailView(meal: $meals[idx])
                    } label: {
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
                    }
                }
            }
            .searchable(text: $searchKey, prompt: "Search for your meals")
            .navigationTitle("Pantry")
            .toolbar {
                Button {
                    // Add sheet
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    // refresh functionality
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}
