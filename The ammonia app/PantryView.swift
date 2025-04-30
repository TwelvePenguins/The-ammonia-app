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
    @State var showDeleteAlert: Bool = false
    
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
                            .swipeActions {
                                Button {
                                    showDeleteAlert = true
                                } label: {
                                    HStack{
                                        Image(systemName: "trash")
                                    }
                                }
                                .tint(Color.red)
                                Button {
                                    meals[idx].isConsumed = true
                                } label: {
                                    HStack{
                                        Image(systemName: "checkmark.square")
                                    }
                                    .animation(.easeIn(duration: 0.2), value: meals[idx].isConsumed)
                                }
                                .tint(Color.accent)
                            }
                            .alert("Are you sure you want to delete this meal?", isPresented: $showDeleteAlert, actions: {
                                Button(role: .cancel) {
                                    print("CanCeLLeD")
                                } label: {
                                    Text("Cancel")
                                }
                                Button(role: .destructive) {
                                    meals.remove(at: idx)
                                } label: {
                                    Text("Delete")
                                }
                            }, message: {
                                Text("This action cannot be undone.")
                            })
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
//                Picker {
//                    Label("Stored Date", systemImage: "tray.and.arrow.down")
//                        .tag(meals.sorted{$0.storedDate < $1.storedDate})
//                    Label("Planned Date", systemImage: "calendar.badge.clock")
//                        .tag(meals.sorted{$0.plannedDate < $1.plannedDate})
//                    Label("Expiry Date", systemImage: "xmark.seal")
//                        .tag(meals.sorted{$0.expiryDate < $1.expiryDate})
//                } label: {
//                    Image(systemName: "arrow.up.arrow.down")
//                }
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
