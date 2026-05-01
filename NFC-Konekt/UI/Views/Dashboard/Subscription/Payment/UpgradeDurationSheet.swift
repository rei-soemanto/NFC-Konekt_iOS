//
//  UpgradeDurationSheet.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 01/05/26.
//

import SwiftUI

struct UpgradeDurationSheet: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let durations = [
        ("MONTHLY", "1 Month"),
        ("SIX_MONTHS", "6 Months"),
        ("YEARLY", "1 Year (Best Value)")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .center, spacing: 8) {
                RoundedRectangle(cornerRadius: 3).fill(Color.gray.opacity(0.3)).frame(width: 40, height: 6)
                Text("Upgrade Plan").font(.title2).fontWeight(.bold).padding(.top, 8)
                Text("Select your new subscription duration.").font(.subheadline).foregroundColor(.secondary)
            }
            
            VStack(spacing: 0) {
                ForEach(Array(durations.enumerated()), id: \.offset) { index, item in
                    Button(action: {
                        Task { await viewModel.initiateUpgrade(duration: item.0) }
                    }) {
                        HStack {
                            Text(item.1).font(.body).fontWeight(.medium).foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                        .padding()
                    }
                    
                    if index < durations.count - 1 {
                        Divider().padding(.horizontal)
                    }
                }
            }
            .background(colorScheme == .dark ? Color.twGray800 : Color(.systemGray6))
            .cornerRadius(16)
            
            Spacer()
        }
        .padding()
        .background(colorScheme == .dark ? Color.twGray900 : .white)
    }
}
