//
//  ConnectButton.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ConnectButton: View {
    let isConnected: Bool
    let hasSubscription: Bool
    let action: () -> Void
    @State private var isLoading = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if isConnected {
            HStack(spacing: 4) {
                Image(systemName: "checkmark")
                Text("Connected")
            }
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(colorScheme == .dark ? Color.green.opacity(0.2) : Color.green.opacity(0.1))
            .foregroundColor(colorScheme == .dark ? .green : .green)
            .cornerRadius(8)
        } else {
            Button(action: {
                if hasSubscription {
                    isLoading = true
                    Task {
                        await action()
                        isLoading = false
                    }
                }
            }) {
                HStack(spacing: 4) {
                    if isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: hasSubscription ? "person.fill.badge.plus" : "lock.fill")
                        Text(hasSubscription ? "Connect" : "Locked")
                    }
                }
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(hasSubscription ? Color.twIndigo600 : (colorScheme == .dark ? Color.gray.opacity(0.3) : Color(.systemGray5)))
                .foregroundColor(hasSubscription ? .white : .gray)
                .cornerRadius(8)
            }
            .disabled(!hasSubscription || isLoading)
        }
    }
}

#Preview("Light Mode") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        
        VStack(spacing: 20) {
            ConnectButton(isConnected: true, hasSubscription: true, action: {})
            
            ConnectButton(isConnected: false, hasSubscription: true, action: {})
            
            ConnectButton(isConnected: false, hasSubscription: false, action: {})
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 20) {
            ConnectButton(isConnected: true, hasSubscription: true, action: {})
            
            ConnectButton(isConnected: false, hasSubscription: true, action: {})
            
            ConnectButton(isConnected: false, hasSubscription: false, action: {})
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
