//
//  AddMemberSheet.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct AddMemberSheet: View {
    @ObservedObject var viewModel: TeamViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var sheetBg: Color { colorScheme == .dark ? .twGray900 : .white }
    var inputBg: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6) }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Add New Member")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Full Name").font(.caption).foregroundColor(.gray)
                    TextField("", text: $viewModel.newMemberName)
                        .padding()
                        .background(inputBg)
                        .cornerRadius(10)
                        .foregroundColor(primaryText)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email Address").font(.caption).foregroundColor(.gray)
                    TextField("", text: $viewModel.newMemberEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(inputBg)
                        .cornerRadius(10)
                        .foregroundColor(primaryText)
                }
            }
            
            Text("Digital cards are activated instantly. The new member will receive an email to set their password.")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: { Task { await viewModel.addMember() } }) {
                HStack {
                    if viewModel.isSaving {
                        ProgressView().tint(.white)
                    } else {
                        Text("Add Member").fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.twIndigo600)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(viewModel.newMemberName.isEmpty || viewModel.newMemberEmail.isEmpty || viewModel.isSaving)
            
            Spacer()
        }
        .padding(24)
        .background(sheetBg.ignoresSafeArea())
    }
}
