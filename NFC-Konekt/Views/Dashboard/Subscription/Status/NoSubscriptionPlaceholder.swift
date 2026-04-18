//
//  NoSubscriptionPlaceholder.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct NoSubscriptionPlaceholder: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle().fill(Color.gray.opacity(0.1)).frame(width: 64, height: 64)
                Image(systemName: "creditcard").foregroundColor(.gray).font(.title)
            }
            Text("No Active Subscription")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .twGray900)
            Text("Upgrade to unlock digital cards and team features.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {}) {
                Text("View Plans")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.twIndigo600)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.twIndigo600.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.top, 8)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.twGray900 : .white)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        NoSubscriptionPlaceholder()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.twGray950.ignoresSafeArea()
        
        NoSubscriptionPlaceholder()
    }
    .preferredColorScheme(.dark)
}
