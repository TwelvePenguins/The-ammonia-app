//
//  NotificationView.swift
//  The ammonia app
//
//  Created by Sae Young  on 16/7/25.
//

import SwiftUI

struct NotificationView: View {
    @Bindable var mealManager: MealManager
    
    var body: some View {
        NavigationView {
            if mealManager.notifications.isEmpty {
                VStack {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 70))
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Text("No Notifications")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("You don't have any notifications yet.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .navigationTitle("Notifications")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(mealManager.notifications) { notification in
                        NotificationItemView(notification: notification)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Notifications")
                .toolbar {
                    Button {
                        mealManager.markAllNotificationsAsRead()
                    } label: {
                        Text("Mark all as read")
                    }
                }
                .onAppear {
                    // Mark all notifications as read when the view appears
                    mealManager.markAllNotificationsAsRead()
                }
            }
        }
    }
}

struct NotificationItemView: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: notification.iconName)
                .font(.title2)
                .foregroundColor(Color(notification.iconColor))
                .frame(width: 30)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(notification.title)
                    .font(.headline)
                    .foregroundColor(notification.isRead ? .primary : Color(notification.iconColor))
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    
                    Text(timeAgo(from: notification.date))
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                .padding(.top, 2)
            }
            
            Spacer()
            
            if !notification.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
                    .padding(.top, 5)
            }
        }
        .padding(.vertical, 8)
    }
    
    func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date.now
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        
        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }
        
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }
        
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        }
        
        return "Just now"
    }
}
