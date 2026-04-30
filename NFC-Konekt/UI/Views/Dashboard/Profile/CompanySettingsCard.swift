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
    let inputBackground: Color
    let primaryText: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "building.2.fill").foregroundColor(.twIndigo600)
                    Text("Corporate Profile").font(.system(size: 16, weight: .bold)).foregroundColor(.twIndigo600)
                }
                Text("Manage your company details visible to your team.").font(.system(size: 12)).foregroundColor(.gray)
            }
            
            HStack(spacing: 16) {
                DropdownMenuBuilder(title: "Industry / Scope", selection: $viewModel.companyScope, options: viewModel.scopeOptions, placeholder: "Select", backgroundColor: inputBackground, textColor: primaryText)
                DropdownMenuBuilder(title: "Speciality", selection: $viewModel.companySpeciality, options: viewModel.specialityOptions, placeholder: "Select", backgroundColor: inputBackground, textColor: primaryText)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("About Company").font(.system(size: 12, weight: .bold)).foregroundColor(.gray).textCase(.uppercase)
                TextEditor(text: $viewModel.companyDescription)
                    .frame(height: 100).padding(8).background(inputBackground).cornerRadius(10).scrollContentBackground(.hidden)
            }
            
            Button(action: { Task { await viewModel.saveCorporateProfile() } }) {
                HStack {
                    if viewModel.isSavingCompany {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Save Company Details").fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Color.twIndigo600).foregroundColor(.white).cornerRadius(10)
            }
            .disabled(viewModel.isSavingCompany)
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.twIndigo600.opacity(0.3), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
