//
//  EmptyStateView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct EmptyHistoryView: View {
    let tab: HistoryTab
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            ZStack {
                Circle()
                    .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
                    .frame(width: 80, height: 80)
                
                Image(systemName: tab == .outbound ? "camera.fill" : "person.crop.rectangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            Text(tab == .outbound ? "You haven't scanned anyone yet." : "No one has scanned your card yet.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}

#Preview("Light Mode") {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        
        VStack(spacing: 60) {
            EmptyHistoryView(tab: .outbound)
            
            EmptyHistoryView(tab: .inbound)
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        
        VStack(spacing: 60) {
            EmptyHistoryView(tab: .outbound)
            
            EmptyHistoryView(tab: .inbound)
        }
    }
    .preferredColorScheme(.dark)
}
