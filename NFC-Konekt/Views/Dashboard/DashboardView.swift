//
//  DashboardView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = DashboardViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView {
            HomeTabView(viewModel: viewModel, authViewModel: authViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            HistoryTabView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            
            ConnectTabView()
                .tabItem {
                    Label("Connect", systemImage: "person.2.fill")
                }
            
            ContactsTabView()
                .tabItem {
                    Label("Cards", systemImage: "lanyardcard.fill")
                }
            
            MenuTabView(authViewModel: authViewModel)
                .tabItem {
                    Label("Menu", systemImage: "line.3.horizontal")
                }
        }
        .accentColor(.twIndigo600)
    }
}

#Preview("Light Mode") {
    DashboardView()
        .environmentObject(AuthViewModel())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    DashboardView()
        .environmentObject(AuthViewModel())
        .preferredColorScheme(.dark)
}
