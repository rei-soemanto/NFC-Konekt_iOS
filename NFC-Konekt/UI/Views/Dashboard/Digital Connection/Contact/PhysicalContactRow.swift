//
//  PhysicalContactRow.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct PhysicalContactRow: View {
    let contact: PhysicalContactDto
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.name)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                
                Text(contact.jobTitle ?? "No Title")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    if let email = contact.email {
                        Label(email, systemImage: "envelope").lineLimit(1)
                    } else if let phone = contact.phone {
                        Label(phone, systemImage: "phone").lineLimit(1)
                    }
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(contact.company ?? "-")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                
                if let web = contact.website {
                    Image(systemName: "globe")
                        .foregroundColor(.twIndigo600)
                        .padding(6)
                        .background(Color.twIndigo600.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
                .font(.caption)
        }
        .padding()
        .background(colorScheme == .dark ? Color.twGray900 : Color.white)
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
