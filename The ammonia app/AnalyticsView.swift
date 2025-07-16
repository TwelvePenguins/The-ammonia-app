//
//  AnalyticsView.swift
//  The ammonia app
//
//  Created by Sae Young on 16/7/25.
//

import SwiftUI

struct AnalyticsView: View {
    @Bindable var mealManager: MealManager
    @State private var selectedPeriod = "Weekly"
    private let periods = ["Weekly", "Monthly", "All Time"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Consumption metrics
                    StatisticsCardView(mealManager: mealManager)
                    
                    // Weekly metrics
                    WeeklyStatsView(mealManager: mealManager)
                    
                    // Daily meal chart
                    DailyMealChartView(mealManager: mealManager)
                    
                    // Efficiency Rating
                    EfficiencyRatingView(mealManager: mealManager)
                }
                .padding()
            }
            .navigationTitle("Food Analytics")
        }
    }
}

struct StatisticsCardView: View {
    @Bindable var mealManager: MealManager
    
    var body: some View {
        let stats = mealManager.getFoodStatistics()
        
        VStack(alignment: .leading, spacing: 15) {
            Text("Food Efficiency")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20) {
                StatisticItem(
                    title: "Consumed",
                    value: "\(stats.consumedMeals)",
                    icon: "checkmark.circle.fill", 
                    color: .green
                )
                
                StatisticItem(
                    title: "Wasted", 
                    value: "\(stats.expiredMeals)",
                    icon: "xmark.circle.fill",
                    color: .red
                )
                
                StatisticItem(
                    title: "Saved",
                    value: "\(stats.savedMeals)", 
                    icon: "heart.circle.fill",
                    color: Color("HighlightPurple")
                )
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Consumption Rate")
                    Spacer()
                    Text("\(Int(stats.consumptionRate))%")
                        .fontWeight(.bold)
                }
                
                ProgressBarView(value: stats.consumptionRate / 100, color: .green)
                
                HStack {
                    Text("Waste Rate")
                    Spacer()
                    Text("\(Int(stats.wasteRate))%")
                        .fontWeight(.bold)
                }
                
                ProgressBarView(value: stats.wasteRate / 100, color: .red)
                
                HStack {
                    Text("Efficiency Rate")
                    Spacer()
                    Text("\(Int(stats.efficiencyRate))%")
                        .fontWeight(.bold)
                }
                
                ProgressBarView(value: stats.efficiencyRate / 100, color: Color("HighlightPurple"))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct StatisticItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProgressBarView: View {
    var value: Double // 0.0 to 1.0
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: geometry.size.width, height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(color)
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
}

struct WeeklyStatsView: View {
    @Bindable var mealManager: MealManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Weekly Statistics")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                ForEach(mealManager.weeklyStats) { weekStat in
                    HStack {
                        Text(weekStat.formattedWeekRange())
                            .font(.subheadline)
                            .frame(width: 120, alignment: .leading)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            WeeklyStat(value: weekStat.mealsConsumed, icon: "fork.knife", color: .green)
                            WeeklyStat(value: weekStat.mealsExpired, icon: "trash", color: .red)
                            WeeklyStat(value: weekStat.mealsSaved, icon: "leaf", color: .green)
                        }
                    }
                    Divider()
                }
                
                HStack {
                    Text("")
                        .frame(width: 120, alignment: .leading)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Text("Consumed")
                            .font(.caption)
                            .frame(width: 60)
                        Text("Wasted")
                            .font(.caption)
                            .frame(width: 60)
                        Text("Saved")
                            .font(.caption)
                            .frame(width: 60)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct WeeklyStat: View {
    var value: Int
    var icon: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text("\(value)")
                .fontWeight(.semibold)
        }
        .frame(width: 60)
    }
}

struct DailyMealChartView: View {
    @Bindable var mealManager: MealManager
    
    var body: some View {
        let dailyData = mealManager.getDailyMealsData()
        
        VStack(alignment: .leading, spacing: 15) {
            Text("Daily Meals")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(dailyData) { data in
                    VStack {
                        Text("\(data.count)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: 25, height: 100)
                                .cornerRadius(5)
                            
                            Rectangle()
                                .fill(Color("HighlightPurple"))
                                .frame(width: 25, height: data.count > 0 ? CGFloat(min(data.count * 20, 100)) : 1)
                                .cornerRadius(5)
                        }
                        
                        Text(data.day)
                            .font(.caption)
                            .padding(.top, 5)
                    }
                    
                    if data.id != dailyData.last?.id {
                        Spacer()
                    }
                }
            }
            .padding(.top, 10)
            
            Text("Meals planned by day")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct EfficiencyRatingView: View {
    @Bindable var mealManager: MealManager
    
    var body: some View {
        let stats = mealManager.getFoodStatistics()
        let efficiency = Int(stats.efficiencyRate)
        
        var ratingText: String {
            if efficiency >= 90 {
                return "Excellent!"
            } else if efficiency >= 75 {
                return "Very Good"
            } else if efficiency >= 60 {
                return "Good"
            } else if efficiency >= 40 {
                return "Fair"
            } else {
                return "Needs Improvement"
            }
        }
        
        var ratingColor: Color {
            if efficiency >= 90 {
                return .green
            } else if efficiency >= 75 {
                return Color.green.opacity(0.8)
            } else if efficiency >= 60 {
                return Color("HighlightPurple")
            } else if efficiency >= 40 {
                return .orange
            } else {
                return .red
            }
        }
        
        VStack(alignment: .leading, spacing: 15) {
            Text("Your Efficiency Rating")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(efficiency)%")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(ratingColor)
                    
                    Text(ratingText)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(ratingColor)
                    
                    Text("Based on your meal consumption patterns")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                CircularProgressView(value: Double(efficiency) / 100, color: ratingColor)
                    .frame(width: 80, height: 80)
            }
            
            Divider()
                .padding(.vertical, 5)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tips to improve:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                BulletPoint(text: "Plan meals according to expiry dates")
                BulletPoint(text: "Set reminders for food that expires soon")
                BulletPoint(text: "Store food properly to extend shelf life")
                BulletPoint(text: "Consider freezing food you won't eat soon")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct BulletPoint: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .foregroundColor(.secondary)
            Text(text)
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}

struct CircularProgressView: View {
    var value: Double // 0.0 to 1.0
    var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 10)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(self.value, 1.0)))
                .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: value)
            
            Text("\(Int(value * 100))%")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
        }
    }
}
