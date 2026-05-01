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
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    @State private var isDrawerOpen = false
    
    @State private var navigateToTeam = false
    @State private var navigateToSubscription = false
    
    init(repository: ProfileRepository) {
        _profileViewModel = StateObject(wrappedValue: AccountViewModel(repository: repository))
    }
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    var inputBackground: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(hex: "#F3F4F6") }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    var dangerZoneBg: Color { colorScheme == .dark ? Color.red.opacity(0.1) : Color.red.opacity(0.05) }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .trailing) {
                
                mainContent
                
                if isDrawerOpen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation(.easeInOut) { isDrawerOpen = false } }
                        .transition(.opacity)
                        .zIndex(1)
                }
                
                drawerMenu
                
                NavigationLink(
                    destination: TeamManagementView(repository: container.teamRepository),
                    isActive: $navigateToTeam
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: SubscriptionStatusView(repository: container.subscriptionRepository),
                    isActive: $navigateToSubscription
                ) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
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
            
            Button(action: {
                withAnimation(.easeInOut) { isDrawerOpen = false }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    navigateToTeam = true
                }
            }) {
                Label("Manage Team", systemImage: "person.3.sequence")
                    .padding().foregroundColor(primaryText)
            }
            
            Button(action: {
                withAnimation(.easeInOut) { isDrawerOpen = false }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    navigateToSubscription = true
                }
            }) {
                Label("Subscription Status", systemImage: "star")
                    .padding().foregroundColor(primaryText)
            }
            
            Spacer()
            Divider().background(Color.gray.opacity(0.2))
            
            HStack {
                Label("Dark Mode", systemImage: isDarkMode ? "moon" : "sun.max")
                    .foregroundColor(primaryText)
                Spacer()
                Toggle("", isOn: $isDarkMode)
                    .labelsHidden()
                    .scaleEffect(0.8)
            }
            .padding()
            
            Button(action: {
                isDrawerOpen = false
                authViewModel.logout()
            }) {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    .fontWeight(.bold)
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

#Preview("Preview") {
    let container = DIContainer()
    let authVM = AuthViewModel(repository: container.authRepository)
    
    return AccountSettingsView(repository: container.profileRepository)
        .environmentObject(authVM)
        .environmentObject(container)
}
