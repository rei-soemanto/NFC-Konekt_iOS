//
//  ProfileSettingsCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ProfileSettingsCard: View {
    @ObservedObject var viewModel: AccountViewModel
    let cardBackground: Color
    @Environment(\.colorScheme) var colorScheme
    
    var inputBackground: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6) }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    var shadowColor: Color { colorScheme == .dark ? .clear : .black.opacity(0.05) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Public Profile")
                .font(.headline)
                .foregroundColor(primaryText)
            
            avatarSection
            
            formSection
            
            saveButton
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private var avatarSection: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.twIndigo600.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 2))
                Text(String(viewModel.fullName.prefix(1)))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.twIndigo600)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Button(action: { /* Trigger PhotosUI */ }) {
                    Text("Change Photo")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.twIndigo600)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Text("JPG, GIF or PNG. Max size of 5MB.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom, 8)
    }
    
    private var formSection: some View {
        VStack(spacing: 16) {
            CustomTextField(label: "Full Name", text: $viewModel.fullName, bg: inputBackground)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Email Address").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                TextField("", text: .constant(viewModel.email))
                    .padding()
                    .background(inputBackground)
                    .cornerRadius(10)
                    .disabled(true)
                    .foregroundColor(.gray)
            }
            
            CustomTextField(label: "Phone Number", text: $viewModel.phone, bg: inputBackground)
            CustomTextField(label: "Company Name", text: $viewModel.companyName, bg: inputBackground)
            CustomTextField(label: "Company Website", text: $viewModel.companyWebsite, bg: inputBackground)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Bio").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                TextEditor(text: $viewModel.bio)
                    .frame(height: 100)
                    .padding(8)
                    .background(inputBackground)
                    .cornerRadius(10)
                    .scrollContentBackground(.hidden)
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: { Task { await viewModel.saveProfile() } }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Save Profile Changes")
                }
            }
            .font(.subheadline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.twIndigo600)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(viewModel.isLoading)
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        ScrollView {
            ProfileSettingsCard(
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
            ProfileSettingsCard(
                viewModel: AccountViewModel(),
                cardBackground: Color(hex: "#111827")
            )
            .padding(.vertical)
        }
    }
    .preferredColorScheme(.dark)
}
