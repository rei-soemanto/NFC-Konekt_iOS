//
//  TeamListCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TeamListCard: View {
    @ObservedObject var viewModel: TeamViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var deletingId: String? = nil
    
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    var shadowColor: Color { colorScheme == .dark ? .clear : .black.opacity(0.05) }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Team Members")
                    .font(.headline)
                    .foregroundColor(primaryText)
                Spacer()
                Button(action: { viewModel.showAddMemberSheet = true }) {
                    Label("Add Member", systemImage: "plus")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.twIndigo600.opacity(0.1))
                        .foregroundColor(.twIndigo600)
                        .cornerRadius(8)
                }
                .disabled(viewModel.currentUsage >= viewModel.maxUsage)
            }
            .padding()
            .background(cardBackground)
            
            Divider()
            
            if viewModel.members.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "person.3.sequence.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No members found.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(cardBackground)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.members) { member in
                        TeamMemberRow(
                            member: member,
                            isDeleting: deletingId == member.id,
                            onEdit: { viewModel.editingMember = member },
                            onDelete: {
                                deletingId = member.id
                                Task {
                                    await viewModel.removeMember(id: member.id)
                                    deletingId = nil
                                }
                            }
                        )
                        if member.id != viewModel.members.last?.id {
                            Divider().padding(.leading, 64)
                        }
                    }
                }
                .background(cardBackground)
            }
        }
        .cornerRadius(16)
        .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview("With Members") {
    let container = DIContainer()
    let viewModel = TeamViewModel(repository: container.teamRepository)
    
    return ZStack {
        Color.twGray100.ignoresSafeArea()
        
        ScrollView {
            TeamListCard(viewModel: viewModel)
                .padding(.vertical)
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Empty State") {
    let container = DIContainer()
    let emptyViewModel = TeamViewModel(repository: container.teamRepository)
    emptyViewModel.members = []
    
    return ZStack {
        Color.twGray950.ignoresSafeArea()
        
        ScrollView {
            TeamListCard(viewModel: emptyViewModel)
                .padding(.vertical)
        }
    }
    .preferredColorScheme(.dark)
}
