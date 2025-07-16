//
//  AnalyticsModel.swift
//  The ammonia app
//
//  Created by Sae Young on 16/7/25.
//

import Foundation

struct FoodStatistics: Codable {
    var totalMeals: Int
    var consumedMeals: Int
    var expiredMeals: Int
    var savedMeals: Int
    
    var consumptionRate: Double {
        totalMeals > 0 ? Double(consumedMeals) / Double(totalMeals) * 100.0 : 0.0
    }
    
    var wasteRate: Double {
        totalMeals > 0 ? Double(expiredMeals) / Double(totalMeals) * 100.0 : 0.0
    }
    
    var efficiencyRate: Double {
        totalMeals > 0 ? Double(savedMeals) / Double(totalMeals) * 100.0 : 0.0
    }
}

struct WeeklyStats: Codable, Identifiable, Hashable {
    var id = UUID()
    var weekStartDate: Date
    var mealsConsumed: Int
    var mealsExpired: Int
    var mealsSaved: Int
    
    func formattedWeekRange() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: weekStartDate) ?? weekStartDate
        
        let startStr = dateFormatter.string(from: weekStartDate)
        let endStr = dateFormatter.string(from: endDate)
        
        return "\(startStr) - \(endStr)"
    }
}

struct DailyMeals: Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var count: Int
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    var dayNum: Int {
        Calendar.current.component(.day, from: date)
    }
}
