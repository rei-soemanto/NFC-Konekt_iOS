//
//  HistoryRowView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct HistoryRowView: View {
    let item: HistoryItem
    let hasSubscription: Bool
    let onConnect: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var cardBackground: Color {
        colorScheme == .dark ? .twGray900 : .white
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? Color.twIndigo600.opacity(0.3) : Color.twIndigo600.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    if let avatar = item.person.avatarUrl {
                        // Assuming you have an AsyncImage setup, mocked here
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.twIndigo600)
                    } else {
                        Text(item.person.initials)
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? .twIndigo600 : .twIndigo600)
                    }
                }
                
                // User Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.person.fullName)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                    
                    Text("\(item.person.jobTitle ?? "-") • \(item.person.companyName ?? "No Company")")
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? .gray : .twGray800)
                    
                    Text(item.person.email)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            Divider()
            
            HStack {
                // Date
                Text(item.scannedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Action Button
                ConnectButton(isConnected: item.isConnected, hasSubscription: hasSubscription, action: onConnect)
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview("Light Mode") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        
        VStack(spacing: 16) {
            HistoryRowView(
                item: HistoryItem(
                    id: "h1",
                    scannedAt: Date(),
                    person: Person(id: "p1", fullName: "Michelle", email: "michelle@example.com", jobTitle: "Designer", companyName: "Creative Studio", avatarUrl: nil),
                    isConnected: true
                ),
                hasSubscription: true,
                onConnect: {}
            )
            
            HistoryRowView(
                item: HistoryItem(
                    id: "h2",
                    scannedAt: Date().addingTimeInterval(-3600),
                    person: Person(id: "p2", fullName: "Antonius Pramudiya", email: "antonius@wraksa.com", jobTitle: "CEO", companyName: "PT. Wraksa Kencana Mukti", avatarUrl: nil),
                    isConnected: false
                ),
                hasSubscription: true,
                onConnect: {}
            )
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 16) {
            HistoryRowView(
                item: HistoryItem(
                    id: "h1",
                    scannedAt: Date(),
                    person: Person(id: "p1", fullName: "Michelle", email: "michelle@example.com", jobTitle: "Designer", companyName: "Creative Studio", avatarUrl: nil),
                    isConnected: true
                ),
                hasSubscription: true,
                onConnect: {}
            )
            
            HistoryRowView(
                item: HistoryItem(
                    id: "h2",
                    scannedAt: Date().addingTimeInterval(-3600),
                    person: Person(id: "p2", fullName: "Antonius Pramudiya", email: "antonius@wraksa.com", jobTitle: "CEO", companyName: "PT. Wraksa Kencana Mukti", avatarUrl: nil),
                    isConnected: false
                ),
                hasSubscription: true,
                onConnect: {}
            )
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
