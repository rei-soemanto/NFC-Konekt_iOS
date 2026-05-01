//
//  ContentView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var container = DIContainer()
    @StateObject private var authViewModel: AuthViewModel
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    init() {
        let rootContainer = DIContainer()
        _container = StateObject(wrappedValue: rootContainer)
        _authViewModel = StateObject(wrappedValue: AuthViewModel(repository: rootContainer.authRepository))
    }
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                DashboardView()
                    .environmentObject(authViewModel)
            } else {
                AuthenticationView(viewModel: authViewModel)
                    .environmentObject(authViewModel)
            }
        }
        .environmentObject(container)
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview("Preview") {
    ContentView()
}
