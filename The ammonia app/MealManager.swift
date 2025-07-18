//
//  MealManager.swift
//  The ammonia app
//
//  Created by Yuhan Du on 14/7/25.
//

import Foundation
import Observation

@Observable class MealManager {
    var meals: [Meal] = [
        Meal(name: "Chicken Sandwiches", storedDate: Date.now, plannedDate: dateFormatter.date(from: "20-07-2025")!, expiryDate: dateFormatter.date(from: "25-07-2025")!), // Should be safe
        Meal(name: "Pepperoni Pizza", storedDate: Date.now, plannedDate: dateFormatter.date(from: "23-07-2025")!, expiryDate: dateFormatter.date(from: "19-07-2025")!), // Should be attention required
        Meal(name: "Beef Noodles", storedDate: Date.now, plannedDate: dateFormatter.date(from: "14-07-2025")!, expiryDate: dateFormatter.date(from: "12-07-2025")!), // Should be expired
        Meal(name: "Satay", storedDate: dateFormatter.date(from: "08-07-2025")!, plannedDate: dateFormatter.date(from: "17-07-2025")!, expiryDate: dateFormatter.date(from: "19-07-2025")!, temperature: .lower, humidity: .higher), // Should be attention required
        Meal(name: "Chicken Pie", storedDate: dateFormatter.date(from: "09-06-2025")!, plannedDate: dateFormatter.date(from: "19-07-2025")!, expiryDate: dateFormatter.date(from: "22-07-2025")!), // Should be safe
    ] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    var upcomingMeals: [Meal] {
        let notEaten   = meals.filter { !$0.isConsumed }
        let stillFresh = notEaten.filter { $0.expiryDate > Date.now }
        let sorted     = stillFresh.sorted { $0.expiryDate < $1.expiryDate }
        let count      = ceil(Double(sorted.count) * 0.6)
        return Array(sorted.prefix(Int(count)))
    }
    
    var sortedMeals: [Meal] {
        get {
            sort(meals: meals, by: selectedSortMethod)
        }
        
        set {
            for meal in newValue {
                let mealIndex = meals.firstIndex(where: { $0.id == meal.id })!
                meals[mealIndex] = meal
            }
        }
    }
    
    var selectedSortMethod = SortingMethods.expiryDate
    
    private func sort(meals: [Meal], by sortingMethod: SortingMethods) -> [Meal] {
        switch sortingMethod {
        case .expiryDate:
            return meals.sorted { $0.expiryDate < $1.expiryDate }
        case .plannedDate:
            return meals.sorted { $0.plannedDate < $1.plannedDate }
        case .storedDate:
            return meals.sorted { $0.storedDate < $1.storedDate }
        }
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "meals.json")
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedMeals = try? jsonEncoder.encode(meals)
        try? encodedMeals?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
        
        if let retrievedMealData = try? Data(contentsOf: archiveURL),
           let mealsDecoded = try? jsonDecoder.decode([Meal].self, from: retrievedMealData) {
            meals = mealsDecoded
        }
        print(archiveURL) // Clearing app data: Head to this file path to find the JSON to delete
    }
}
