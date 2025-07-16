//
//  NotificationModel.swift
//  The ammonia app
//
//  Created by Sae Young  on 16/7/25.
//

import Foundation

struct NotificationItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var message: String
    var date: Date
    var isRead: Bool = false
    var type: NotificationType
    var relatedMealId: UUID?
    
    enum NotificationType: String, Codable {
        case expirySoon = "Expiry Soon"
        case expired = "Expired"
        case planned = "Planned Meal"
        case system = "System"
    }
    
    var iconName: String {
        switch type {
        case .expirySoon:
            return "exclamationmark.triangle"
        case .expired:
            return "xmark.seal"
        case .planned:
            return "calendar.badge.clock"
        case .system:
            return "bell"
        }
    }
    
    var iconColor: String {
        switch type {
        case .expirySoon:
            return "Orange"
        case .expired:
            return "Red"
        case .planned:
            return "Green"
        case .system:
            return "HighlightPurple"
        }
    }
}
