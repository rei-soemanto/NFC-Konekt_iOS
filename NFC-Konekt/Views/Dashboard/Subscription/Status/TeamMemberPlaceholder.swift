//
//  TeamMemberPlaceholder.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TeamMemberPlaceholder: View {
    let managerName: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(Color.twIndigo600.opacity(0.1)).frame(width: 48, height: 48)
                    Image(systemName: "person.3.sequence.fill").foregroundColor(.twIndigo600).font(.title3)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Team Plan Active")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                    Text("Managed by \(managerName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.twGray900 : .white)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        VStack {
            TeamMemberPlaceholder(managerName: "Antonius Pramudiya")
            Spacer()
        }
        .padding(.top)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.twGray950.ignoresSafeArea()
        
        VStack {
            TeamMemberPlaceholder(managerName: "Antonius Pramudiya")
            Spacer()
        }
        .padding(.top)
    }
    .preferredColorScheme(.dark)
}
