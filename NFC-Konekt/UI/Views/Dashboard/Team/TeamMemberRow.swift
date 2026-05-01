//
//  TeamMemberRow.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TeamMemberRow: View {
    let member: TeamMemberDto // 👈 Updated to DTO
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
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(primaryText)
                
                HStack(spacing: 6) {
                    Text(member.email)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    if let job = member.jobTitle, !job.isEmpty {
                        Text(job.uppercased())
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 4).padding(.vertical, 2)
                            .background(Color.twIndigo600.opacity(0.1))
                            .foregroundColor(.twIndigo600)
                            .cornerRadius(4)
                    }
                    
                    if member.isCompanyPublic == false {
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
            
            HStack(spacing: 4) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                }
                
                Button(action: onDelete) {
                    if isDeleting {
                        ProgressView().scaleEffect(0.6)
                            .frame(width: 32, height: 32)
                    } else {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .frame(width: 32, height: 32)
                    }
                }
                .disabled(isDeleting)
            }
        }
        .padding(16)
    }
}
