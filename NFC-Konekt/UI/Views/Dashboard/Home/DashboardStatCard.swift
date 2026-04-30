//
//  DashboardStatCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import SwiftUI

struct DashboardStatCard: View {
    let icon: String
    let iconBgColor: Color
    let iconColor: Color
    let value: String
    let title: String
    let subtitle: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    var textPrimary: Color { colorScheme == .dark ? .white : .black }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconBgColor)
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(textPrimary)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textPrimary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 8, x: 0, y: 4)
    }
}
