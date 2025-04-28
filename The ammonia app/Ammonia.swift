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
    var plannedDate: Date //TODO: Change after newMeal
    var isAlertOn: Bool = false
    var expiryDate: Date //TODO: Change after implementing prediction
    var isConsumed: Bool = false
    var status: MealStatus {
        if Date.now <= expiryDate {
            if expiryDate <= plannedDate {
                return .attentionRequired
            } else {
                return .safe
            }
        } else {
            return .expired
        }
    }
}

struct Ammonia {
    var date: Date
    var day: String
    var count: Int = 0
}

enum MealStatus: String {
    case safe = "Safe"
    case expired = "Expired"
    case attentionRequired = "Attention Required"
}

func daysBetween(start: Date, end: Date, expiry: Bool = false) -> String {
    var returnString: [String] = []
    
    let duration = start.timeIntervalSince(end) // Issue accessing thru pantry
    returnString.append(Date(timeInterval: duration, since: end).formatted(.dateTime.dayOfYear()))
    returnString.append(abs(duration) >= 86400 ? "day" : "days")
    
    if expiry {
        returnString.insert(duration >= 0 ? "Expired" : "Expiring in", at: 0)
        returnString.append(duration >= 0 ? "ago" : "")
    }
    
    return returnString.joined(separator: " ")
}

//TODO: change to array + join functionality???

func findAttribute(status: MealStatus, find: String) -> String {
    
    var returnString = ""
    
    if find == "SF" {
        if status == .attentionRequired {
            returnString = "exclamationmark.triangle"
        } else if status == .expired {
            returnString = "xmark.seal"
        } else {
            returnString = "checkmark.seal"
        }
        return returnString
    } else if find == "Colour" {
        if status == .attentionRequired {
            returnString =  "Orange"
        } else if status == .expired {
            returnString = "Red"
        } else {
            returnString = "Green"
        }
        return returnString
    } else {
        return returnString
    }
    
}
