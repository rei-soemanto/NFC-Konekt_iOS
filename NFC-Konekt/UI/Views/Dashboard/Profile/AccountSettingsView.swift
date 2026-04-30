//
//  AccountSettingsView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct AccountSettingsView: View {
    @StateObject private var profileViewModel: AccountViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var container: DIContainer
    
    @State private var isDrawerOpen = false
    
    // Inject Repository
    init(repository: ProfileRepository) {
        _profileViewModel = StateObject(wrappedValue: AccountViewModel(repository: repository))
    }
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    var inputBackground: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(hex: "#F3F4F6") }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    var dangerZoneBg: Color { colorScheme == .dark ? Color.red.opacity(0.1) : Color.red.opacity(0.05) }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            
            // 1. Main View Content
            mainContent
            
            // 2. Dimmed Overlay when drawer is open
            if isDrawerOpen {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation(.easeInOut) { isDrawerOpen = false } }
                    .transition(.opacity)
                    .zIndex(1)
            }
            
            // 3. Right-Side Drawer
            drawerMenu
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews extracted to help the SwiftUI Compiler
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            // Custom Top App Bar
            HStack {
                Spacer()
                Button(action: { withAnimation(.easeInOut) { isDrawerOpen = true } }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(primaryText)
                        .padding()
                }
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Account Settings")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(primaryText)
                        Text("Manage your personal profile and account details.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    ProfileSettingsCard(viewModel: profileViewModel, cardBackground: cardBackground, inputBackground: inputBackground, primaryText: primaryText)
                        .padding(.horizontal)
                    
                    AddressSettingsCard(viewModel: profileViewModel, cardBackground: cardBackground, inputBackground: inputBackground, primaryText: primaryText)
                        .padding(.horizontal)
                    
                    if profileViewModel.isCorporateAdmin {
                        CompanySettingsCard(viewModel: profileViewModel, cardBackground: cardBackground, inputBackground: inputBackground, primaryText: primaryText)
                            .padding(.horizontal)
                    }
                    
                    SecuritySettingsCard(authViewModel: authViewModel, cardBackground: cardBackground, inputBackground: inputBackground, primaryText: primaryText, dangerZoneBg: dangerZoneBg)
                        .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .background(appBackground.ignoresSafeArea())
        .task {
            await profileViewModel.loadProfile()
        }
    }
    
    private var drawerMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Account Menu")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            
            Divider().background(Color.gray.opacity(0.2))
            
            Button(action: { isDrawerOpen = false }) {
                Label("Manage Team", systemImage: "person.3.sequence")
                    .padding().foregroundColor(primaryText)
            }
            
            Button(action: { isDrawerOpen = false }) {
                Label("Subscription Status", systemImage: "star")
                    .padding().foregroundColor(primaryText)
            }
            
            Spacer()
            Divider().background(Color.gray.opacity(0.2))
            
            HStack {
                Label("Dark Mode", systemImage: colorScheme == .dark ? "moon" : "sun.max")
                    .foregroundColor(primaryText)
                Spacer()
                Toggle("", isOn: .constant(colorScheme == .dark))
                    .labelsHidden()
                    .scaleEffect(0.8)
            }
            .padding()
            
            Button(action: {
                isDrawerOpen = false
                authViewModel.logout()
            }) {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    .fontWeight(.bold) // <--- FIXED HERE
                    .foregroundColor(.red)
                    .padding()
            }
            .padding(.bottom, 16)
        }
        .frame(width: 280, alignment: .leading)
        .background(cardBackground.ignoresSafeArea())
        .offset(x: isDrawerOpen ? 0 : 280)
        .zIndex(2)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let container = DIContainer()
    let authVM = AuthViewModel(repository: container.authRepository)
    
    return AccountSettingsView(repository: container.profileRepository)
        .environmentObject(authVM)
        .environmentObject(container)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    let authVM = AuthViewModel(repository: container.authRepository)
    
    return AccountSettingsView(repository: container.profileRepository)
        .environmentObject(authVM)
        .environmentObject(container)
        .preferredColorScheme(.dark)
}
