//
//  TeamMemberRow.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TeamMemberRow: View {
    let member: TeamMember
    let isDeleting: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.twIndigo600.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(Circle().stroke(Color.twIndigo600.opacity(0.3), lineWidth: 1))
                Text(String(member.fullName.prefix(1)))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.twIndigo600)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(member.fullName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(primaryText)
                
                HStack(spacing: 6) {
                    Text(member.email)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if let job = member.jobTitle, !job.isEmpty {
                        Text(job)
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 4).padding(.vertical, 2)
                            .background(Color.twIndigo600.opacity(0.1))
                            .foregroundColor(.twIndigo600)
                            .cornerRadius(4)
                    }
                    
                    if !member.isCompanyPublic {
                        HStack(spacing: 2) {
                            Image(systemName: "eye.slash.fill")
                            Text("HIDDEN")
                        }
                        .font(.system(size: 8, weight: .bold))
                        .padding(.horizontal, 4).padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.gray)
                        .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: onDelete) {
                    if isDeleting {
                        ProgressView().scaleEffect(0.6)
                            .frame(width: 30, height: 30)
                    } else {
                        Image(systemName: "trash.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .disabled(isDeleting)
            }
        }
        .padding()
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        VStack(spacing: 0) {
            TeamMemberRow(
                member: TeamMember(id: "1", fullName: "Antonius Pramudiya", email: "antonius@wraksa.com", jobTitle: "CEO", isCompanyPublic: true, avatarUrl: nil),
                isDeleting: false,
                onEdit: {},
                onDelete: {}
            )
            
            Divider().padding(.leading, 64)
            
            TeamMemberRow(
                member: TeamMember(id: "2", fullName: "Budi Santoso", email: "budi@wraksa.com", jobTitle: "Engineer", isCompanyPublic: false, avatarUrl: nil),
                isDeleting: false,
                onEdit: {},
                onDelete: {}
            )
            
            Divider().padding(.leading, 64)
            
            TeamMemberRow(
                member: TeamMember(id: "3", fullName: "Sarah Jenkins", email: "sarah@wraksa.com", jobTitle: nil, isCompanyPublic: true, avatarUrl: nil),
                isDeleting: true,
                onEdit: {},
                onDelete: {}
            )
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.twGray950.ignoresSafeArea()
        
        VStack(spacing: 0) {
            TeamMemberRow(
                member: TeamMember(id: "1", fullName: "Antonius Pramudiya", email: "antonius@wraksa.com", jobTitle: "CEO", isCompanyPublic: true, avatarUrl: nil),
                isDeleting: false,
                onEdit: {},
                onDelete: {}
            )
            
            Divider().padding(.leading, 64)
            
            TeamMemberRow(
                member: TeamMember(id: "2", fullName: "Budi Santoso", email: "budi@wraksa.com", jobTitle: "Engineer", isCompanyPublic: false, avatarUrl: nil),
                isDeleting: false,
                onEdit: {},
                onDelete: {}
            )
            
            Divider().padding(.leading, 64)
            
            TeamMemberRow(
                member: TeamMember(id: "3", fullName: "Sarah Jenkins", email: "sarah@wraksa.com", jobTitle: nil, isCompanyPublic: true, avatarUrl: nil),
                isDeleting: true,
                onEdit: {},
                onDelete: {}
            )
        }
        .background(Color.twGray900)
        .cornerRadius(16)
        .padding()
    }
    .preferredColorScheme(.dark)
}
