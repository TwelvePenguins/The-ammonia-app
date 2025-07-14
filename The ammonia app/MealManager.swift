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
        Meal(name: "Chicken Sandwiches", storedDate: Date.now, plannedDate: dateFormatter.date(from: "10-05-2025")!, expiryDate: dateFormatter.date(from: "13-05-2025")!), // Should be safe
        Meal(name: "Hawaiian Pizza", storedDate: Date.now, plannedDate: dateFormatter.date(from: "14-05-2025")!, expiryDate: dateFormatter.date(from: "11-05-2025")!), // Should be attention required
        Meal(name: "Beef Noodles", storedDate: Date.now, plannedDate: dateFormatter.date(from: "03-05-2025")!, expiryDate: dateFormatter.date(from: "28-04-2025")!), // Should be expired
        Meal(name: "Bak Kuh Teh", storedDate: dateFormatter.date(from: "28-04-2025")!, plannedDate: dateFormatter.date(from: "17-05-2025")!, expiryDate: dateFormatter.date(from: "14-05-2025")!), // Should be attention required
        Meal(name: "Chicken Stew", storedDate: dateFormatter.date(from: "29-04-2025")!, plannedDate: dateFormatter.date(from: "12-05-2025")!, expiryDate: dateFormatter.date(from: "13-05-2025")!), // Should be safe
    ] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
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
    }
}
