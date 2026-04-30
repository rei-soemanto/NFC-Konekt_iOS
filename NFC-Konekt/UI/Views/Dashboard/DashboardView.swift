//
//  DashboardView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @EnvironmentObject var container: DIContainer
    
    init(repository: DashboardRepository) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(repository: repository))
    }
    
    var body: some View {
        TabView {
            HomeTabView(viewModel: viewModel, authViewModel: authViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            HistoryTabView(viewModel: HistoryViewModel(
                historyRepository: container.historyRepository,
                connectRepository: container.connectRepository,
                subscriptionRepository: container.subscriptionRepository
            ))
            .tabItem {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
            
            ConnectTabView()
                .tabItem {
                    Label("Connect", systemImage: "person.2.fill")
                }
            
            ContactsTabView(viewModel: ContactsViewModel(repository: container.contactRepository))
                .tabItem {
                    Label("Cards", systemImage: "lanyardcard.fill")
                }
            
            AccountSettingsView(repository: container.profileRepository)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .accentColor(.twIndigo600)
        .task {
            await viewModel.loadData()
        }
    }
}
