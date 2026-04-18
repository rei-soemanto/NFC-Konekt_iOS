//
//  SecuritySettingsCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct SecuritySettingsCard: View {
    @ObservedObject var viewModel: AccountViewModel
    let cardBackground: Color
    @Environment(\.colorScheme) var colorScheme
    
    var inputBackground: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6) }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    var shadowColor: Color { colorScheme == .dark ? .clear : .black.opacity(0.05) }
    
    var cancelBtnBg: Color { colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2) }
    var confirmBoxBg: Color { colorScheme == .dark ? Color.black.opacity(0.2) : Color.red.opacity(0.05) }
    var dangerZoneBg: Color { colorScheme == .dark ? Color.red.opacity(0.1) : Color.red.opacity(0.05) }
    
    var body: some View {
        VStack(spacing: 24) {
            passwordSection
            dangerZoneSection
        }
        .padding(.horizontal)
    }
    
    private var passwordSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Change Password", systemImage: "lock.fill")
                .font(.headline)
                .foregroundColor(.twIndigo600)
            
            VStack(spacing: 12) {
                SecureField("Current Password", text: $viewModel.currentPassword)
                    .padding().background(inputBackground).cornerRadius(10)
                SecureField("New Password", text: $viewModel.newPassword)
                    .padding().background(inputBackground).cornerRadius(10)
            }
            
            Button(action: { Task { await viewModel.changePassword() } }) {
                Text("Update Password")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.twIndigo600)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
    }
    
    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Danger Zone", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundColor(.red)
            
            Text("Deleting your account is permanent. If you are a Team Manager, your team members will be unlinked and lose their premium benefits.")
                .font(.caption)
                .foregroundColor(.red.opacity(0.8))
            
            if !viewModel.showDeleteConfirmation {
                Button(action: { withAnimation { viewModel.showDeleteConfirmation = true } }) {
                    Text("Delete Account")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Are you absolutely sure? This cannot be undone.")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(primaryText)
                    
                    HStack(spacing: 12) {
                        Button(action: { viewModel.deleteAccount() }) {
                            Text("Yes, Delete My Account")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { withAnimation { viewModel.showDeleteConfirmation = false } }) {
                            Text("Cancel")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(cancelBtnBg)
                                .foregroundColor(primaryText)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(confirmBoxBg)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red.opacity(0.3), lineWidth: 1))
            }
        }
        .padding()
        .background(dangerZoneBg)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.2), lineWidth: 1))
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        ScrollView {
            SecuritySettingsCard(
                viewModel: AccountViewModel(),
                cardBackground: .white
            )
            .padding(.vertical)
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.twGray950.ignoresSafeArea()
        
        ScrollView {
            SecuritySettingsCard(
                viewModel: AccountViewModel(),
                cardBackground: Color(hex: "#111827") 
            )
            .padding(.vertical)
        }
    }
    .preferredColorScheme(.dark)
}
