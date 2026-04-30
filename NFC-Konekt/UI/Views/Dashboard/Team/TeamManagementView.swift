//
//  TeamManagementView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TeamManagementView: View {
    @StateObject private var viewModel: TeamViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(repository: TeamRepository) {
        _viewModel = StateObject(wrappedValue: TeamViewModel(repository: repository))
    }
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var body: some View {
        ZStack {
            appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Team")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(primaryText)
                        Text("Manage your corporate members and seat allocation.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    TeamStatsCard(viewModel: viewModel)
                    
                    TeamListCard(viewModel: viewModel)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showAddMemberSheet) {
            AddMemberSheet(viewModel: viewModel)
        }
        .sheet(item: $viewModel.editingMember) { member in
            EditMemberSheet(viewModel: viewModel, member: member)
        }
        .task {
            await viewModel.loadTeam()
        }
    }
}

#Preview("Light Mode") {
    let container = DIContainer()
    return NavigationView {
        TeamManagementView(repository: container.teamRepository)
    }
    .environmentObject(container)
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    return NavigationView {
        TeamManagementView(repository: container.teamRepository)
    }
    .environmentObject(container)
    .preferredColorScheme(.dark)
}
