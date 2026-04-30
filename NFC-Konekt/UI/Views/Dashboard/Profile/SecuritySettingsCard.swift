//
//  SecuritySettingsCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct SecuritySettingsCard: View {
    @ObservedObject var authViewModel: AuthViewModel
    let cardBackground: Color
    let inputBackground: Color
    let primaryText: Color
    let dangerZoneBg: Color
    
    var body: some View {
        VStack(spacing: 24) {
            // Change Password
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill").foregroundColor(.twIndigo600)
                    Text("Change Password").font(.system(size: 16, weight: .bold)).foregroundColor(.twIndigo600)
                }
                
                SecureField("Current Password", text: $authViewModel.currentPassword)
                    .padding().background(inputBackground).cornerRadius(10)
                SecureField("New Password", text: $authViewModel.newPassword)
                    .padding().background(inputBackground).cornerRadius(10)
                SecureField("Confirm Password", text: $authViewModel.securityConfirmPassword)
                    .padding().background(inputBackground).cornerRadius(10)
                
                Button(action: { Task { await authViewModel.changePassword() } }) {
                    Text("Update Password")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 20).padding(.vertical, 12)
                        .background(Color.twIndigo600).foregroundColor(.white).cornerRadius(8)
                }
            }
            .padding().background(cardBackground).cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            
            // Danger Zone
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                    Text("Danger Zone").font(.system(size: 16, weight: .bold)).foregroundColor(.red)
                }
                
                Text("Deleting your account is permanent. If you are a Team Manager, your team members will be unlinked and lose their premium benefits.")
                    .font(.system(size: 12)).foregroundColor(.red.opacity(0.8))
                
                Button(action: { withAnimation { authViewModel.showDeleteConfirmation = true } }) {
                    Text("Delete Account")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 20).padding(.vertical, 12)
                        .background(Color.red).foregroundColor(.white).cornerRadius(8)
                }
            }
            .padding().background(dangerZoneBg).cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.2), lineWidth: 1))
            
            // Alert Dialog mapping
            if authViewModel.showDeleteConfirmation {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Confirm Deletion").font(.headline).foregroundColor(primaryText)
                    Text("This action cannot be undone. All your data will be permanently erased. Please enter your password to confirm.").font(.subheadline)
                    
                    SecureField("Account Password", text: $authViewModel.deletePasswordInput)
                        .padding().background(inputBackground).cornerRadius(10)
                    
                    HStack {
                        Button(action: { Task { await authViewModel.deleteAccount() } }) {
                            Text("Delete Permanently").font(.caption).fontWeight(.bold).padding().background(Color.red).foregroundColor(.white).cornerRadius(8)
                        }
                        Button(action: { withAnimation { authViewModel.showDeleteConfirmation = false } }) {
                            Text("Cancel").font(.caption).fontWeight(.bold).padding().foregroundColor(primaryText)
                        }
                    }
                }
                .padding().background(cardBackground).cornerRadius(16).shadow(radius: 10)
            }
        }
    }
}
