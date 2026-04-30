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
    let inputBackground: Color
    let primaryText: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Public Profile")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(primaryText)
            
            HStack(spacing: 16) {

                ZStack {
                    Circle()
                        .fill(Color.twIndigo600.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 2))
                    
                    if let url = viewModel.avatarUrl.toFullImageURL() {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            case .failure:
                                Text(String(viewModel.fullName.prefix(1)).uppercased())
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.twIndigo600)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Text(String(viewModel.fullName.prefix(1)).uppercased())
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.twIndigo600)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Button(action: { /* Image Picker logic */ }) {
                        Text("Change Photo")
                            .font(.system(size: 12, weight: .bold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.twIndigo600)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Text("JPG, GIF or PNG. Max size of 5MB.")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
            
            VStack(spacing: 16) {
                CustomTextField(label: "Full Name", text: $viewModel.fullName, bg: inputBackground)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email Address").font(.system(size: 12, weight: .bold)).foregroundColor(.gray).textCase(.uppercase)
                    TextField("", text: .constant(viewModel.email))
                        .padding().background(inputBackground).cornerRadius(10).disabled(true).foregroundColor(.gray)
                }
                
                CustomTextField(label: "Phone Number", text: $viewModel.phone, bg: inputBackground)
                CustomTextField(label: "Company Name", text: $viewModel.companyName, bg: inputBackground)
                CustomTextField(label: "Company Website", text: $viewModel.companyWebsite, bg: inputBackground)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bio").font(.system(size: 12, weight: .bold)).foregroundColor(.gray).textCase(.uppercase)
                    TextEditor(text: $viewModel.bio)
                        .frame(height: 100).padding(8).background(inputBackground).cornerRadius(10).scrollContentBackground(.hidden)
                }
            }
            
            Divider().background(Color.gray.opacity(0.2))
            
            // Nested Social Links (Matching Android)
            SocialLinksCard(viewModel: viewModel, inputBackground: inputBackground, primaryText: primaryText)
            
            Button(action: { Task { await viewModel.savePersonalProfile() } }) {
                HStack {
                    if viewModel.isSavingPersonal {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Save Profile Changes").fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Color.twIndigo600).foregroundColor(.white).cornerRadius(10)
            }
            .disabled(viewModel.isSavingPersonal)
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
