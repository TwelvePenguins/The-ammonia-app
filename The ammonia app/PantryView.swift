//
//  PantryView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import SwiftUI

struct PantryView: View {
    
    @Bindable var mealManager: MealManager
    
    @State private var searchKey: String = ""
    @State private var deleteMealID: Meal.ID? = nil    // NEW: track which index to delete
    @State var showDeleteAlert: Bool = false
    @State var refresh: Bool = false
    
    private var allMatching: [Int] {
        guard !searchKey.isEmpty else {
            return Array(mealManager.sortedMeals.indices)
        }
        return mealManager.sortedMeals.indices.filter { mealManager.sortedMeals[$0].name.localizedCaseInsensitiveContains(searchKey) }
    }
    
    private var consumedIndices: [Int] {
        allMatching.filter { mealManager.sortedMeals[$0].isConsumed }
    }
    
    private var unconsumedIndices: [Int] {
        allMatching.filter { !mealManager.sortedMeals[$0].isConsumed }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Unconsumed")) {
                    ForEach(unconsumedIndices, id: \.self) { idx in
                        PantryRowView(meal: $mealManager.sortedMeals[idx], mealManager: mealManager)
                            .swipeActions {
                                Button {
                                    showDeleteAlert = true
                                    deleteMealID = mealManager.sortedMeals[idx].id
                                } label: {
                                    HStack{
                                        Image(systemName: "trash")
                                    }
                                }
                                .tint(Color.red)
                                Button {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        mealManager.sortedMeals[idx].isConsumed = true
                                    }
                                } label: {
                                    HStack{
                                        Image(systemName: "checkmark.square")
                                    }
                                }
                                .tint(Color.accent)
                            }
                    }
                }
                if !consumedIndices.isEmpty {
                    Section(header: Text("Consumed")) {
                        ForEach(consumedIndices, id: \.self) { idx in
                            PantryRowView(meal: $mealManager.sortedMeals[idx], mealManager: mealManager)
                                .swipeActions {
                                    Button {
                                        showDeleteAlert = true
                                        deleteMealID = mealManager.sortedMeals[idx].id
                                    } label: {
                                        HStack{
                                            Image(systemName: "trash")
                                        }
                                    }
                                    .tint(Color.red)
                                    Button {
                                        withAnimation(.snappy(duration: 0.2)) {
                                            mealManager.sortedMeals[idx].isConsumed = false
                                        }
                                    } label: {
                                        HStack{
                                            Image(systemName: "x.square.fill")
                                        }
                                    }
                                    .tint(Color.accent)
                                }
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
                
                Menu {
                    Button {
                        withAnimation {
                            mealManager.selectedSortMethod = .storedDate
                        }
                        refresh.toggle()
                    } label: {
                        HStack {
                            if mealManager.selectedSortMethod == .storedDate {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                            Label("Stored Date", systemImage: "tray.and.arrow.down")
                        }
                    }
                    Button {
                        withAnimation {
                            mealManager.selectedSortMethod = .plannedDate
                        }
                        refresh.toggle()
                    } label: {
                        HStack {
                            if mealManager.selectedSortMethod == .plannedDate {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                            Label("Planned Date", systemImage: "calendar.badge.clock")
                        }
                    }
                    Button {
                        withAnimation {
                            mealManager.selectedSortMethod = .expiryDate
                        }
                        refresh.toggle()
                    } label: {
                        HStack {
                            if mealManager.selectedSortMethod == .expiryDate {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                            Label("Expiry Date", systemImage: "xmark.seal")
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
            .alert("Are you sure you want to delete this meal?", isPresented: $showDeleteAlert, actions: {
                Button(role: .cancel) {
                    deleteMealID = nil
                } label: {
                    Text("Cancel")
                }
                Button(role: .destructive) {
                    showDeleteAlert = false
                    let idToDelete = deleteMealID
                    deleteMealID = nil
                    DispatchQueue.main.async {
                        if let id = idToDelete,
                           let idxToRemove = mealManager.meals.firstIndex(where: { $0.id == id }) {
                            withAnimation(.snappy(duration: 0.2)) {
                                mealManager.meals.remove(at: idxToRemove)
                            }
                        }
                    }
                    deleteMealID = nil
                } label: {
                    Text("Delete")
                }
            }, message: {
                Text("This action cannot be undone.")
            })
        }
    }
}
