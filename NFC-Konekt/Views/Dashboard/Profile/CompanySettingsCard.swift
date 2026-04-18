//
//  CompanySettingsCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct CompanySettingsCard: View {
    @ObservedObject var viewModel: AccountViewModel
    let cardBackground: Color
    @Environment(\.colorScheme) var colorScheme
    
    var inputBackground: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6) }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    var shadowColor: Color { colorScheme == .dark ? .clear : .black.opacity(0.05) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Label("Corporate Profile", systemImage: "building.2.fill")
                .font(.headline)
                .foregroundColor(.twIndigo600)
            
            Text("Manage your company details visible to your team.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 16) {
                HStack {
                    dropdownMenu(title: "Industry / Scope", selection: $viewModel.companyScope, options: viewModel.scopeOptions)
                    dropdownMenu(title: "Speciality", selection: $viewModel.companySpeciality, options: viewModel.specialityOptions)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("About Company").font(.caption).fontWeight(.bold).foregroundColor(.secondary)
                    TextEditor(text: $viewModel.companyDescription)
                        .frame(height: 100)
                        .padding(8)
                        .background(inputBackground)
                        .cornerRadius(10)
                        .scrollContentBackground(.hidden)
                }
            }
            
            Button(action: { Task { await viewModel.saveProfile() } }) {
                Text("Save Company Details")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.twIndigo600)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.twIndigo600.opacity(0.3), lineWidth: 1))
        .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private func dropdownMenu(title: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.caption).fontWeight(.bold).foregroundColor(.secondary)
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection.wrappedValue = option }
                }
            } label: {
                HStack {
                    Text(selection.wrappedValue).foregroundColor(primaryText)
                    Spacer()
                    Image(systemName: "chevron.down").foregroundColor(.gray).font(.caption)
                }
                .padding()
                .background(inputBackground)
                .cornerRadius(10)
            }
        }
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        ScrollView {
            CompanySettingsCard(
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
            CompanySettingsCard(
                viewModel: AccountViewModel(),
                cardBackground: Color(hex: "#111827")
            )
            .padding(.vertical)
        }
    }
    .preferredColorScheme(.dark)
}
