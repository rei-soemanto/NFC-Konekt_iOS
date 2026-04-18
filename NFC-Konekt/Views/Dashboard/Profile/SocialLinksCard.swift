//
//  SocialLinksCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct SocialLinksCard: View {
    @ObservedObject var viewModel: AccountViewModel
    let cardBackground: Color
    @Environment(\.colorScheme) var colorScheme
    
    var inputBackground: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6) }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    var shadowColor: Color { colorScheme == .dark ? .clear : .black.opacity(0.05) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Social Profiles")
                    .font(.headline)
                    .foregroundColor(primaryText)
                Spacer()
                Button(action: { viewModel.addSocialLink() }) {
                    Label("Add New", systemImage: "plus")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.twIndigo600)
                }
            }
            
            if viewModel.socialLinks.isEmpty {
                Text("No social links added yet.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5])).foregroundColor(.gray.opacity(0.5)))
            } else {
                ForEach($viewModel.socialLinks) { $link in
                    HStack {
                        Picker("Platform", selection: $link.platform) {
                            ForEach(viewModel.platformOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 120)
                        .padding(.vertical, 8)
                        .background(inputBackground)
                        .cornerRadius(8)
                        
                        TextField("https://...", text: $link.url)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(inputBackground)
                            .cornerRadius(8)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        if let index = viewModel.socialLinks.firstIndex(where: { $0.id == link.id }) {
                            Button(action: { viewModel.removeSocialLink(at: index) }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red.opacity(0.8))
                                    .padding(10)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        ScrollView {
            SocialLinksCard(
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
            SocialLinksCard(
                viewModel: AccountViewModel(),
                cardBackground: Color(hex: "#111827")
            )
            .padding(.vertical)
        }
    }
    .preferredColorScheme(.dark)
}
