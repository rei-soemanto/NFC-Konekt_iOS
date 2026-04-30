//
//  EmptyStateView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct EmptyConnectionView: View {
    let icon: String
    let title: String
    let message: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.gray.opacity(0.5))
            Text(title).font(.headline).foregroundColor(colorScheme == .dark ? .white : .twGray900)
            Text(message).font(.subheadline).foregroundColor(.secondary)
        }
        .padding(.vertical, 40)
    }
}
