//
//  DigitalConnectionRow.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct DigitalConnectionRow: View {
    let connection: DigitalConnectionDto 
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color.twIndigo600.opacity(0.1)).frame(width: 50, height: 50)
                    Text(String(connection.fullName.prefix(1))).font(.headline).foregroundColor(.twIndigo600)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(connection.fullName).font(.headline).foregroundColor(colorScheme == .dark ? .white : .twGray900)
                    Text(connection.jobTitle ?? "No Title").font(.subheadline).foregroundColor(.secondary)
                    Text(connection.email).font(.caption).foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            
            if let company = connection.companyName {
                HStack(spacing: 12) {
                    Image(systemName: "building.2.fill").foregroundColor(.gray).frame(width: 30, height: 30)
                        .background(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white).cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(company).font(.subheadline).fontWeight(.bold).foregroundColor(colorScheme == .dark ? .white : .twGray900)
                        
                        HStack {
                            if let scope = connection.companyScope {
                                Text(scope).font(.system(size: 10, weight: .bold)).padding(.horizontal, 6).padding(.vertical, 2).background(Color.blue.opacity(0.1)).foregroundColor(.blue).cornerRadius(4)
                            }
                            if let spec = connection.companySpeciality {
                                Text(spec).font(.system(size: 10, weight: .bold)).padding(.horizontal, 6).padding(.vertical, 2).background(Color.purple.opacity(0.1)).foregroundColor(.purple).cornerRadius(4)
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.1) : Color(.systemGray6))
            }
        }
        .background(colorScheme == .dark ? Color.twGray900 : Color.white)
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
