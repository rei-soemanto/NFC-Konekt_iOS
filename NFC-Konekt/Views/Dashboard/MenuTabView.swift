//
//  MenuTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct MenuTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var userPlan: String = "COMPANY"
    @State private var isInherited: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                // Team Management Section
                if !isInherited && ["GROUP", "COMPANY", "CORPORATE"].contains(userPlan) {
                    Section(header: Text("Management")) {
                        NavigationLink(destination: Text("Team View Modules Loading...")) {
                            Label("My Team", systemImage: "person.3.sequence.fill")
                        }
                    }
                }
                
                // Subscription Section
                Section(header: Text("Billing")) {
                    NavigationLink(destination: Text("Subscription Status Modules Loading...")) {
                        Label("Subscription Status", systemImage: "doc.text.fill")
                    }
                    
                    if !isInherited {
                        NavigationLink(destination: Text("Payment Settings Modules Loading...")) {
                            Label("Payment Methods", systemImage: "creditcard.fill")
                        }
                    }
                }
                
                // Account Section
                Section(header: Text("Settings")) {
                    
                    // FIXED: Routes to the actual view we just built!
                    NavigationLink(destination: AccountSettingsView()) {
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
    MenuTabView(authViewModel: AuthViewModel())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MenuTabView(authViewModel: AuthViewModel())
        .preferredColorScheme(.dark)
}
