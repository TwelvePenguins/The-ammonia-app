//
//  Ammonia.swift
//  The ammonia app
//
//  Created by Yuhan Du on 15/4/25.
//

import Foundation

struct Meal: Hashable, Identifiable, Codable {
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
    
    //Non-core anomaly detection: Check if anomaly exists (ie. normal for both or not) then act accordingly.
    var temperature: AnomalyTrend = .normal
    var humidity: AnomalyTrend = .normal
}

struct Ammonia: Identifiable, Hashable {
    var id = UUID()
    var date: Int
    var count: Double = 0.0
    var day: String
}

enum MealStatus: String {
    case safe = "Safe"
    case expired = "Expired"
    case attentionRequired = "Attention Required"
}

enum AnomalyTrend: String, Codable {
    case higher = "Higher than usual"
    case normal = "Normal"
    case lower = "Lower than usual"
}

func daysBetween(start: Date, end: Date, expiry: Bool = false) -> String {
    var returnString: [String] = []
    
    let duration = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
    
    if duration == 0 {
        returnString.append("Today")
        if expiry {
            returnString.insert(duration <= 0 ? "Expired" : "Expiring", at: 0)
        }
    } else {
        returnString.append(String(abs(duration)))
        returnString.append(abs(duration) >= 86400 ? "day" : "days")
        returnString.append(duration <= 0 ? "ago" : "later")
        if expiry {
            returnString.insert(duration <= 0 ? "Expired" : "Expiring in", at: 0)
        }
    }
    
    return returnString.joined(separator: " ")
}

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
