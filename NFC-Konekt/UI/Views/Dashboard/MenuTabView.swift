//
//  MenuTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct MenuTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @EnvironmentObject var container: DIContainer
    
    @State private var userPlan: String = "COMPANY"
    @State private var isInherited: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                if !isInherited && ["GROUP", "COMPANY", "CORPORATE"].contains(userPlan) {
                    Section(header: Text("Management")) {
                        NavigationLink(destination: TeamManagementView(repository: container.teamRepository)) {
                            Label("My Team", systemImage: "person.3.sequence.fill")
                        }
                    }
                }
                
                Section(header: Text("Billing")) {
                    NavigationLink(destination: SubscriptionStatusView(repository: container.subscriptionRepository)) {
                        Label("Subscription Status", systemImage: "doc.text.fill")
                    }
                    
                    if !isInherited {
                        NavigationLink(destination: Text("Payment Settings Modules Loading...")) {
                            Label("Payment Methods", systemImage: "creditcard.fill")
                        }
                    }
                }
                
                Section(header: Text("Settings")) {
                    
                    NavigationLink(destination: AccountSettingsView(repository: container.profileRepository)) {
                        Label("Account", systemImage: "person.crop.circle.fill")
                    }
                    
                    Button(action: {
                        withAnimation {
                            authViewModel.logout()
                        }
                    }) {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Menu")
            .listStyle(InsetGroupedListStyle())
        }
        .accentColor(.twIndigo600)
    }
}

#Preview("Light Mode") {
    let container = DIContainer()
    let authVM = AuthViewModel(repository: container.authRepository)
    
    return MenuTabView(authViewModel: authVM)
        .environmentObject(container)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    let authVM = AuthViewModel(repository: container.authRepository)
    
    return MenuTabView(authViewModel: authVM)
        .environmentObject(container)
        .preferredColorScheme(.dark)
}
