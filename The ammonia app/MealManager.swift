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
            generateNotifications() // Notifications functionality updated by Sae Young 16/07/2025
            updateAnalytics()
        }
    }
    var notifications: [NotificationItem] = [
        NotificationItem(
            title: "Meal Expiring Soon",
            message: "Hawaiian Pizza is expiring in 2 days",
            date: Date.now.addingTimeInterval(-3600),
            type: .expirySoon
        ),
        NotificationItem(
            title: "Meal Expired",
            message: "Beef Noodles has expired. Please discard it.",
            date: Date.now.addingTimeInterval(-7200),
            type: .expired
        ),
        NotificationItem(
            title: "Planned Meal Reminder",
            message: "You planned to eat Chicken Stew today!",
            date: Date.now.addingTimeInterval(-10800),
            type: .planned
        ),
        NotificationItem(
            title: "Welcome to Ammonia",
            message: "Start tracking your meals to reduce food waste!",
            date: Date.now.addingTimeInterval(-86400),
            type: .system
        )
    ] {
        didSet {
            saveNotifications()
        }
    }
    
    var weeklyStats: [WeeklyStats] = [
        WeeklyStats(
            weekStartDate: Calendar.current.date(byAdding: .day, value: -28, to: Date.now)!,
            mealsConsumed: 6,
            mealsExpired: 2,
            mealsSaved: 4
        ),
        WeeklyStats(
            weekStartDate: Calendar.current.date(byAdding: .day, value: -21, to: Date.now)!,
            mealsConsumed: 8,
            mealsExpired: 1,
            mealsSaved: 7
        ),
        WeeklyStats(
            weekStartDate: Calendar.current.date(byAdding: .day, value: -14, to: Date.now)!,
            mealsConsumed: 7,
            mealsExpired: 0,
            mealsSaved: 7
        ),
        WeeklyStats(
            weekStartDate: Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!,
            mealsConsumed: 9,
            mealsExpired: 1,
            mealsSaved: 8
        )
    ] {
        didSet {
            saveWeeklyStats()
        }
    }
        
    init() {
        load()
    }
    
    private func getMealsArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "meals.json")
    }
    
    private func getNotificationsArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "notifications.json")
    }
    
    private func getWeeklyStatsArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "weekly_stats.json")
    }
    
    private func save() {
        let archiveURL = getMealsArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedMeals = try? jsonEncoder.encode(meals)
        try? encodedMeals?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func saveNotifications() {
        let archiveURL = getNotificationsArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedNotifications = try? jsonEncoder.encode(notifications)
        try? encodedNotifications?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func saveWeeklyStats() {
        let archiveURL = getWeeklyStatsArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedStats = try? jsonEncoder.encode(weeklyStats)
        try? encodedStats?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let mealsURL = getMealsArchiveURL()
        let notificationsURL = getNotificationsArchiveURL()
        let weeklyStatsURL = getWeeklyStatsArchiveURL()
        let jsonDecoder = JSONDecoder()
        
        // Load meals
        if let retrievedMealData = try? Data(contentsOf: mealsURL),
           let mealsDecoded = try? jsonDecoder.decode([Meal].self, from: retrievedMealData) {
            meals = mealsDecoded
        }
        
        // Load notifications
        if let retrievedNotificationData = try? Data(contentsOf: notificationsURL),
           let notificationsDecoded = try? jsonDecoder.decode([NotificationItem].self, from: retrievedNotificationData) {
            notifications = notificationsDecoded
        }
        
        // Load weekly stats
        if let retrievedStatsData = try? Data(contentsOf: weeklyStatsURL),
           let statsDecoded = try? jsonDecoder.decode([WeeklyStats].self, from: retrievedStatsData) {
            weeklyStats = statsDecoded
        }
    }
    
    func generateNotifications() {
        let calendar = Calendar.current
        let today = Date.now
        
        for meal in meals {
            // Generate notification for meals expiring within 2 days
            let daysTillExpiry = calendar.dateComponents([.day], from: today, to: meal.expiryDate).day ?? 0
            
            if daysTillExpiry <= 2 && daysTillExpiry >= 0 && !meal.isConsumed {
                let existingNotification = notifications.first { notification in
                    if let relatedId = notification.relatedMealId, relatedId == meal.id, notification.type == .expirySoon {
                        return true
                    }
                    return false
                }
                
                if existingNotification == nil {
                    let expiryMessage = daysTillExpiry == 0 ? "today" : "in \(daysTillExpiry) day\(daysTillExpiry > 1 ? "s" : "")"
                    let newNotification = NotificationItem(
                        title: "Meal Expiring Soon",
                        message: "\(meal.name) is expiring \(expiryMessage)",
                        date: Date.now,
                        type: .expirySoon,
                        relatedMealId: meal.id
                    )
                    notifications.insert(newNotification, at: 0)
                }
            }
            
            // Generate notification for expired meals
            if meal.expiryDate < today && !meal.isConsumed {
                let existingNotification = notifications.first { notification in
                    if let relatedId = notification.relatedMealId, relatedId == meal.id, notification.type == .expired {
                        return true
                    }
                    return false
                }
                
                if existingNotification == nil {
                    let newNotification = NotificationItem(
                        title: "Meal Expired",
                        message: "\(meal.name) has expired. Please discard it.",
                        date: Date.now,
                        type: .expired,
                        relatedMealId: meal.id
                    )
                    notifications.insert(newNotification, at: 0)
                }
            }
            
            // Generate notification for meals planned for today
            if calendar.isDateInToday(meal.plannedDate) && !meal.isConsumed {
                let existingNotification = notifications.first { notification in
                    if let relatedId = notification.relatedMealId, relatedId == meal.id, notification.type == .planned {
                        return true
                    }
                    return false
                }
                
                if existingNotification == nil {
                    let newNotification = NotificationItem(
                        title: "Planned Meal Reminder",
                        message: "You planned to eat \(meal.name) today!",
                        date: Date.now,
                        type: .planned,
                        relatedMealId: meal.id
                    )
                    notifications.insert(newNotification, at: 0)
                }
            }
        }
    }
    
    func updateAnalytics() {
        // Update weekly stats for current week if needed
        let calendar = Calendar.current
        
        // Find the start of the current week (Sunday)
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date.now)
        let startOfWeek = calendar.date(from: components) ?? Date.now
        
        // Check if we already have stats for this week
        if !weeklyStats.contains(where: { calendar.isDate($0.weekStartDate, inSameDayAs: startOfWeek) }) {
            // Create new week stats
            let newWeekStats = WeeklyStats(
                weekStartDate: startOfWeek,
                mealsConsumed: 0,
                mealsExpired: 0,
                mealsSaved: 0
            )
            weeklyStats.append(newWeekStats)
        }
        
        // Update current week's stats
        if let currentWeekIndex = weeklyStats.firstIndex(where: { calendar.isDate($0.weekStartDate, inSameDayAs: startOfWeek) }) {
            var currentStats = weeklyStats[currentWeekIndex]
            
            currentStats.mealsConsumed = meals.filter { $0.isConsumed }.count
            currentStats.mealsExpired = meals.filter { $0.expiryDate < Date.now && !$0.isConsumed }.count
            currentStats.mealsSaved = meals.filter { $0.isConsumed && $0.expiryDate >= $0.plannedDate }.count
            
            weeklyStats[currentWeekIndex] = currentStats
        }
    }
    
    func getFoodStatistics() -> FoodStatistics {
        let totalMeals = meals.count
        let consumedMeals = meals.filter { $0.isConsumed }.count
        let expiredMeals = meals.filter { $0.expiryDate < Date.now && !$0.isConsumed }.count
        let savedMeals = meals.filter { $0.isConsumed && $0.expiryDate >= $0.plannedDate }.count
        
        return FoodStatistics(
            totalMeals: totalMeals,
            consumedMeals: consumedMeals,
            expiredMeals: expiredMeals,
            savedMeals: savedMeals
        )
    }
    
    func getDailyMealsData(for days: Int = 7) -> [DailyMeals] {
        var result: [DailyMeals] = []
        let calendar = Calendar.current
        
        for i in 0..<days {
            let day = calendar.date(byAdding: .day, value: -i, to: Date.now) ?? Date.now
            let startOfDay = calendar.startOfDay(for: day)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
            
            let count = meals.filter { meal in
                let mealDate = calendar.startOfDay(for: meal.plannedDate)
                return mealDate >= startOfDay && mealDate < endOfDay
            }.count
            
            result.append(DailyMeals(date: day, count: count))
        }
        
        return result.reversed()
    }
    
    func markAllNotificationsAsRead() {
        for i in 0..<notifications.count {
            notifications[i].isRead = true
        }
    }
    
    func getUnreadNotificationsCount() -> Int {
        return notifications.filter { !$0.isRead }.count
    }
}
