//
//  LockedStateView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct LockedNetworkView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.twIndigo600.opacity(0.1))
                    .frame(width: 100, height: 100)
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.twIndigo600)
            }
            
            Text("Unlock Your Network")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .twGray900)
            
            Text("The Connect feature allows you to build a professional network. Upgrade your plan to start saving connections.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: { /* Navigate to upgrade */ }) {
                Text("Upgrade Now")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.twIndigo600)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        LockedNetworkView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.twGray950.ignoresSafeArea()
        LockedNetworkView()
    }
    .preferredColorScheme(.dark)
}
