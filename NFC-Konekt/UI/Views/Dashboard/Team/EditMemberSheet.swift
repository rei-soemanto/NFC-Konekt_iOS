//
//  EditMemberSheet.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct EditMemberSheet: View {
    @ObservedObject var viewModel: TeamViewModel
    let member: TeamMemberDto
    
    @State private var jobTitle: String
    @State private var isPublic: Bool
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: TeamViewModel, member: TeamMemberDto) {
        self.viewModel = viewModel
        self.member = member
        _jobTitle = State(initialValue: member.jobTitle ?? "")
        _isPublic = State(initialValue: member.isCompanyPublic ?? true)
    }
    
    var sheetBg: Color { colorScheme == .dark ? .twGray900 : .white }
    var inputBg: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6) }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Edit Member")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Basic Info (Read Only)
            VStack(alignment: .leading, spacing: 4) {
                Text(member.fullName).font(.system(size: 16, weight: .medium)).foregroundColor(.gray)
                Text(member.email).font(.system(size: 14)).foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Role in Company (e.g. Manager)").font(.caption).foregroundColor(.gray)
                    TextField("", text: $jobTitle)
                        .padding()
                        .background(inputBg)
                        .cornerRadius(10)
                        .foregroundColor(primaryText)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Public Visibility").font(.system(size: 16)).foregroundColor(primaryText)
                        Text("Show this member on the corporate profile.").font(.system(size: 12)).foregroundColor(.gray)
                    }
                    Spacer()
                    Toggle("", isOn: $isPublic)
                        .labelsHidden()
                        .tint(.twIndigo600)
                }
            }
            
            Button(action: { Task { await viewModel.saveEditedMember(id: member.id, jobTitle: jobTitle, isPublic: isPublic) } }) {
                HStack {
                    if viewModel.isSaving {
                        ProgressView().tint(.white)
                    } else {
                        Text("Save Changes").fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.twIndigo600)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(viewModel.isSaving)
            
            Spacer()
        }
        .padding(24)
        .background(sheetBg.ignoresSafeArea())
    }
}
