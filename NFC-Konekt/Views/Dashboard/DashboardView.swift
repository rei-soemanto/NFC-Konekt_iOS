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
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("NFC Card Management Modules Loading...")
                .tabItem {
                    Label("My Cards", systemImage: "lanyardcard.fill")
                }
            
            Text("Settings Modules Loading...")
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
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
