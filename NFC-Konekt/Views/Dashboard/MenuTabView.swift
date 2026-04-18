//
//  MenuTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct MenuTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    // TODO: Bind these to your actual User model from AuthViewModel
    // Mocking the web logic state for demonstration
    @State private var userPlan: String = "COMPANY" // "GROUP", "COMPANY", "CORPORATE", or "BASIC"
    @State private var isInherited: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                // Team Management Section
                if !isInherited && ["GROUP", "COMPANY", "CORPORATE"].contains(userPlan) {
                    Section(header: Text("Management")) {
                        NavigationLink(destination: Text("Team View")) {
                            Label("My Team", systemImage: "person.3.sequence.fill")
                        }
                        
                        if ["COMPANY", "CORPORATE"].contains(userPlan) {
                            NavigationLink(destination: Text("NFC Writer View")) {
                                Label("Write Cards", systemImage: "square.and.pencil")
                            }
                        }
                    }
                }
                
                // Subscription Section
                Section(header: Text("Billing")) {
                    NavigationLink(destination: Text("Subscription Status")) {
                        Label("Subscription Status", systemImage: "doc.text.fill")
                    }
                    
                    if !isInherited {
                        NavigationLink(destination: Text("Payment Settings")) {
                            Label("Payment Methods", systemImage: "creditcard.fill")
                        }
                    }
                }
                
                // Account Section
                Section(header: Text("Settings")) {
                    NavigationLink(destination: Text("Account Settings")) {
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
