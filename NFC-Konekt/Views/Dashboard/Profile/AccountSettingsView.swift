//
//  AccountSettingsView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct AccountSettingsView: View {
    @StateObject private var viewModel = AccountViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var body: some View {
        ZStack {
            appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    ProfileSettingsCard(viewModel: viewModel, cardBackground: cardBackground)
                    
                    SocialLinksCard(viewModel: viewModel, cardBackground: cardBackground)
                    
                    AddressSettingsCard(cardBackground: cardBackground)
                    
                    if viewModel.isCorporateAdmin {
                        CompanySettingsCard(viewModel: viewModel, cardBackground: cardBackground)
                    }
                    
                    SecuritySettingsCard(viewModel: viewModel, cardBackground: cardBackground)
                    
                    Spacer(minLength: 40)
                }
            }
        }
    }
    
    // Extracted Header to reduce nesting in the main body
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Account Settings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(primaryText)
            Text("Manage your personal profile and account details.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#Preview("Light Mode") {
    AccountSettingsView().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    AccountSettingsView().preferredColorScheme(.dark)
}
