//
//  TabButton.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TabButton: View {
    let title: String
    let icon: String
    let isActive: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: icon)
                    Text(title)
                        .font(.footnote)
                        .fontWeight(.bold)
                }
                .foregroundColor(isActive ? .twIndigo600 : (colorScheme == .dark ? .gray : .twGray800))
                
                Rectangle()
                    .fill(isActive ? Color.twIndigo600 : Color.clear)
                    .frame(height: 2)
            }
            .padding(.top, 16)
            .background(isActive ? (colorScheme == .dark ? Color.twIndigo600.opacity(0.1) : Color.twIndigo600.opacity(0.05)) : Color.clear)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Light Mode") {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        
        HStack(spacing: 0) {
            TabButton(title: "Scanned By Me", icon: "qrcode.viewfinder", isActive: true) { }
            
            TabButton(title: "Users Scanning Me", icon: "eye.fill", isActive: false) { }
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        
        HStack(spacing: 0) {
            TabButton(title: "Scanned By Me", icon: "qrcode.viewfinder", isActive: true) { }
            
            TabButton(title: "Users Scanning Me", icon: "eye.fill", isActive: false) { }
        }
    }
    .preferredColorScheme(.dark)
}
