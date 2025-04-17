//
//  Ammonia.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import Foundation

struct Meal: Hashable, Identifiable {
    var id = UUID()
    var name: String
    var storedDate: Date = Date.now
    var plannedDate: Date = Date.distantPast //TODO: Change after newMeal
    var isAlertOn: Bool = false
    var expiryDate: Date = Date(timeInterval: 12318, since: Date.now) //TODO: Change after implementing prediction
    var isConsumed: Bool = false
    var status: MealStatus = MealStatus.safe
}

struct Ammonia {
    var date: Date
    var day: String
    var count: Int = 0
}

enum MealStatus: String {
    case safe
    case expired
    case attentionRequired
}

func daysBetween(start: Date, end: Date) -> String {
    let duration = DateInterval(start: start, end: end).duration
    let returnString = Date(timeInterval: duration, since: end).formatted(.dateTime.dayOfYear()) + (abs(duration) <= 86400 ? " day" : " days")
    return returnString
}

//TODO: change to array + join functionality???

func findAttribute(status: MealStatus, find: String) -> String {
    if find == "SF" {
        if status == .attentionRequired {
            return "exclamationmark.triangle"
        } else if status == .expired {
            return "xmark.seal"
        } else {
            return "checkmark.seal"
        }
    } else if find == "Colour" {
        if status == .attentionRequired {
            return "Orange"
        } else if status == .expired {
            return "Red"
        } else {
            return "Green"
        }
    } else {
        return ""
    }
}
