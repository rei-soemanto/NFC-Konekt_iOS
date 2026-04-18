//
//  EditMemberSheet.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct EditMemberSheet: View {
    @ObservedObject var viewModel: TeamViewModel
    @State private var editableMember: TeamMember
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: TeamViewModel, member: TeamMember) {
        self.viewModel = viewModel
        _editableMember = State(initialValue: member)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    Text(editableMember.fullName)
                        .foregroundColor(.gray)
                    Text(editableMember.email)
                        .foregroundColor(.gray)
                }
                
                Section(header: Text("Role & Visibility")) {
                    TextField("Role in Company (e.g. Manager)", text: Binding(
                        get: { editableMember.jobTitle ?? "" },
                        set: { editableMember.jobTitle = $0 }
                    ))
                    
                    Toggle(isOn: $editableMember.isCompanyPublic) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Public Visibility")
                                .font(.body)
                            Text("Show this member on the corporate profile.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .tint(.twIndigo600)
                }
            }
            .navigationTitle("Edit Member")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Save") {
                    Task { await viewModel.saveEditedMember(editableMember) }
                }
                .font(.headline)
                .disabled(viewModel.isLoading)
            )
        }
    }
}

#Preview("Light Mode") {
    EditMemberSheet(
        viewModel: TeamViewModel(),
        member: TeamMember(
            id: "preview-id",
            fullName: "Antonius Pramudiya",
            email: "antonius@wraksa.com",
            jobTitle: "CEO",
            isCompanyPublic: true,
            avatarUrl: nil
        )
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    EditMemberSheet(
        viewModel: TeamViewModel(),
        member: TeamMember(
            id: "preview-id",
            fullName: "Antonius Pramudiya",
            email: "antonius@wraksa.com",
            jobTitle: "CEO",
            isCompanyPublic: true,
            avatarUrl: nil
        )
    )
    .preferredColorScheme(.dark)
}
