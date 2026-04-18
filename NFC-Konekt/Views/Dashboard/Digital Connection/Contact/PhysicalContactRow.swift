//
//  PhysicalContactRow.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct PhysicalContactRow: View {
    let contact: PhysicalContact
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

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        VStack(spacing: 16) {
            PhysicalContactRow(contact: PhysicalContact(
                id: "p1",
                name: "Budi Santoso",
                email: "budi.s@techindo.id",
                phone: "+62 812 3456 7890",
                company: "Tech Indo",
                website: "techindo.id",
                jobTitle: "Senior Engineer",
                notes: nil,
                isRegisteredMember: true
            ))
            
            PhysicalContactRow(contact: PhysicalContact(
                id: "p2",
                name: "Linda Wijaya",
                email: nil,
                phone: "+62 855 1122 3344",
                company: "Retail Group",
                website: nil,
                jobTitle: "Manager",
                notes: nil,
                isRegisteredMember: false
            ))
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.twGray950.ignoresSafeArea()
        
        VStack(spacing: 16) {
            PhysicalContactRow(contact: PhysicalContact(
                id: "p1",
                name: "Budi Santoso",
                email: "budi.s@techindo.id",
                phone: "+62 812 3456 7890",
                company: "Tech Indo",
                website: "techindo.id",
                jobTitle: "Senior Engineer",
                notes: nil,
                isRegisteredMember: true
            ))
            
            PhysicalContactRow(contact: PhysicalContact(
                id: "p2",
                name: "Linda Wijaya",
                email: nil,
                phone: "+62 855 1122 3344",
                company: "Retail Group",
                website: nil,
                jobTitle: "Manager",
                notes: nil,
                isRegisteredMember: false
            ))
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
