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
    
    private var allMatching: [Int] {
        guard !searchKey.isEmpty else {
            return Array(meals.indices)
        }
        return meals.indices.filter { meals[$0].name.localizedCaseInsensitiveContains(searchKey) }
    }
    
    private var consumedIndices: [Int] {
            allMatching.filter { meals[$0].isConsumed }
        }
    
    private var unconsumedIndices: [Int] {
        allMatching.filter { !meals[$0].isConsumed }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Unconsumed")) {
                    ForEach(unconsumedIndices, id: \.self) { idx in
                        PantryRowView(idx: idx, meals: $meals)
                    }
                }
                Section(header: Text("Consumed")) {
                    ForEach(consumedIndices, id: \.self) { idx in
                        PantryRowView(idx: idx, meals: $meals)
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
