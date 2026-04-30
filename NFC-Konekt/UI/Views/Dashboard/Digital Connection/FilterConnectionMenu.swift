//
//  FilterMenu.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct FilterConnectionMenu: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: { selection = option }) {
                    HStack {
                        Text(option)
                        if selection == option { Image(systemName: "checkmark") }
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text(selection == "All" ? title : selection)
                    .lineLimit(1)
            }
            .font(.subheadline)
            .padding(10)
            .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
            .foregroundColor(.twIndigo600)
            .cornerRadius(10)
        }
    }
}

struct FilterMenu_Previews: View {
    @State private var selection = "All"
    let options = ["All", "Technology", "Design", "Retail", "Finance"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Selected: \(selection)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            FilterConnectionMenu(
                title: "Industry",
                selection: $selection,
                options: options
            )
        }
    }
}

#Preview("Light Mode") {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        FilterMenu_Previews()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        FilterMenu_Previews()
    }
    .preferredColorScheme(.dark)
}
