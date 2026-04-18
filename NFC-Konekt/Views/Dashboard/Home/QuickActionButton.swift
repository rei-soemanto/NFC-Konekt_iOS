//
//  QuickActionButton.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let cardBackground: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
        }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? .white : .twGray800)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(cardBackground)
            .cornerRadius(16)
            .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview("Light Mode") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        
        QuickActionButton(
            icon: "wave.3.right",
            title: "Write NFC",
            color: .blue,
            cardBackground: .white
        )
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        QuickActionButton(
            icon: "qrcode.viewfinder",
            title: "Scan QR",
            color: .purple,
            cardBackground: Color(UIColor.systemGray6)
        )
        .padding()
    }
    .preferredColorScheme(.dark)
}
