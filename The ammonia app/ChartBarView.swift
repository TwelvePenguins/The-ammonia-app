//
//  ChartBarView.swift
//  The ammonia app
//
//  Created by Yuhan Du on 29/4/25.
//

import SwiftUI

struct ChartBarView: View {
    
    @State var date: Int
    @State var value: Int
    @State var day: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.accent, lineWidth: 3)
                    .frame(width: 25, height: CGFloat(value*30 + 25)) //Probably change 30 to minimum value of the week
                    .foregroundStyle(.clear)
                Circle()
                    .frame(height: 28)
                    .foregroundStyle(Color.highlightPurple)
                    .shadow(radius: 3, y: 1)
                    .offset(y: 3)
                Text("\(date)")
                    .font(.callout)
            }
            Text(day)
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}
