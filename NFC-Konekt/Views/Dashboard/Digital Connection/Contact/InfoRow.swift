//
//  InfoRow.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String?
    var isLink: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.twIndigo600.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(.twIndigo600)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                if let val = value {
                    if isLink {
                        Text(val)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.twIndigo600)
                    } else {
                        Text(val)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                    }
                } else {
                    Text("N/A")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview("Light Mode") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        
        VStack(spacing: 0) {
            InfoRow(icon: "envelope.fill", title: "Email Address", value: "budi.s@techindo.id")
            
            Divider().padding(.leading, 56)
            
            InfoRow(icon: "globe", title: "Website", value: "techindo.id", isLink: true)
            
            Divider().padding(.leading, 56)
            
            InfoRow(icon: "phone.fill", title: "Phone Number", value: nil)
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 0) {
            InfoRow(icon: "envelope.fill", title: "Email Address", value: "budi.s@techindo.id")
            
            Divider().padding(.leading, 56)
            
            InfoRow(icon: "globe", title: "Website", value: "techindo.id", isLink: true)
            
            Divider().padding(.leading, 56)
            
            InfoRow(icon: "phone.fill", title: "Phone Number", value: nil)
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
        .padding()
    }
    .preferredColorScheme(.dark)
}
