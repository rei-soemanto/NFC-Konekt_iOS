//
//  AddMemberSheet.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct AddMemberSheet: View {
    @ObservedObject var viewModel: TeamViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var inputBackground: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6) }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Member Details")) {
                    TextField("Full Name", text: $viewModel.newMemberName)
                        .textContentType(.name)
                    
                    TextField("Email Address", text: $viewModel.newMemberEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(footer: Text("Digital cards are activated instantly. The new member will receive an email to set their password.")) {
                }
            }
            .navigationTitle("Add Member")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Add") {
                    Task { await viewModel.addMember() }
                }
                .font(.headline)
                .disabled(viewModel.newMemberName.isEmpty || viewModel.newMemberEmail.isEmpty || viewModel.isLoading)
            )
        }
    }
}

#Preview("Light Mode") {
    AddMemberSheet(viewModel: TeamViewModel())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    AddMemberSheet(viewModel: TeamViewModel())
        .preferredColorScheme(.dark)
}
