//
//  Ammonia.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import Foundation

struct Meal {
    var name: String
    var storedDate: Date = Date.now
    var plannedDate: Date = Date.distantPast //TODO: Change after newMeal
    var isAlertOn: Bool = false
    var expiryDate: Date = Date(timeInterval: 12318, since: Date.now) //TODO: Change after implementing prediction
    var isConsumed: Bool = false
}

struct Ammonia {
    var date: Date
    var day: String
    var count: Int = 0
}
