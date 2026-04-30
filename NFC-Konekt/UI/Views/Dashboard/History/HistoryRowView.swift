//
//  HistoryRowView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct HistoryRowView: View {
    let item: HistoryItemDto
    let hasSubscription: Bool
    let onConnect: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var textPrimary: Color { colorScheme == .dark ? .white : .twGray900 }
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.twIndigo600.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                if let url = item.person.avatarUrl.toFullImageURL() {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFill().frame(width: 50, height: 50).clipShape(Circle())
                        } else {
                            FallbackInitial(name: item.person.fullName)
                        }
                    }
                } else {
                    FallbackInitial(name: item.person.fullName)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.person.fullName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(textPrimary)
                
                if let job = item.person.jobTitle, let company = item.person.companyName {
                    Text("\(job) at \(company)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                } else if let company = item.person.companyName {
                    Text(company)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Text(formatDate(item.scannedAt))
                    .font(.system(size: 10))
                    .foregroundColor(.gray.opacity(0.8))
            }
            
            Spacer()
            
            if item.isConnected {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Connected")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.green)
                }
            } else {
                Button(action: onConnect) {
                    Text("Connect")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(hasSubscription ? Color.twIndigo600 : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!hasSubscription)
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        let basicFormatter = ISO8601DateFormatter()
        if let date = basicFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}

private struct FallbackInitial: View {
    let name: String
    var body: some View {
        Text(String(name.prefix(1)).uppercased())
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.twIndigo600)
    }
}
