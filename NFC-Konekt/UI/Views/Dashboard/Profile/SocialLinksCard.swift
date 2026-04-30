//
//  SocialLinksCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct SocialLinksCard: View {
    @ObservedObject var viewModel: AccountViewModel
    let inputBackground: Color
    let primaryText: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Social Profiles").font(.system(size: 18, weight: .bold)).foregroundColor(primaryText)
                Spacer()
                Button(action: { viewModel.addSocialLink() }) {
                    Label("Add New", systemImage: "plus").font(.system(size: 12, weight: .bold)).foregroundColor(.twIndigo600)
                }
            }
            
            if viewModel.socialLinks.isEmpty {
                Text("No social links added yet.")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach($viewModel.socialLinks) { $link in
                    HStack(spacing: 8) {
                        DropdownMenuBuilder(
                            title: "", selection: $link.platform, options: viewModel.platformOptions,
                            placeholder: "Platform", backgroundColor: inputBackground, textColor: primaryText
                        )
                        .frame(width: 110)
                        
                        TextField("https://...", text: $link.url)
                            .padding()
                            .background(inputBackground)
                            .cornerRadius(10)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.top, 6) // Align with dropdown
                        
                        Button(action: { viewModel.removeSocialLink(id: link.id) }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.red.opacity(0.8))
                        }
                        .padding(.top, 6)
                    }
                }
            }
        }
    }
}
