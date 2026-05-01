//
//  NFC_KonektApp.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

@main
struct NFC_KonektApp: App {
    let container = DIContainer()
    @StateObject var authViewModel: AuthViewModel
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    init() {
        _authViewModel = StateObject(wrappedValue: AuthViewModel(repository: DIContainer().authRepository))
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    DashboardView()
                        .environmentObject(container)
                } else {
                    AuthenticationView(viewModel: authViewModel)
                }
            }
            .environmentObject(authViewModel)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
