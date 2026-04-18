//
//  ContactsTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ContactsTabView: View {
    @StateObject private var viewModel = ContactsViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    
    var body: some View {
        NavigationView {
            ZStack {
                appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    Text("Physical Cards")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 16)
                    
                    if viewModel.contacts.isEmpty {
                        // Hard Empty State (No contacts at all)
                        VStack(spacing: 20) {
                            Spacer()
                            ZStack {
                                Circle().fill(Color.twIndigo600.opacity(0.1)).frame(width: 80, height: 80)
                                Image(systemName: "person.crop.rectangle").font(.largeTitle).foregroundColor(.twIndigo600)
                            }
                            Text("No Contacts Yet").font(.title3).fontWeight(.bold)
                            Text("Scan a physical business card to add your first contact.")
                                .font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal)
                            
                            Button(action: { /* Action to open scanner */ }) {
                                Text("Scan Now")
                                    .fontWeight(.bold).padding().frame(width: 200)
                                    .background(Color.twIndigo600).foregroundColor(.white).cornerRadius(12)
                            }
                            Spacer()
                        }
                    } else {
                        VStack(spacing: 12) {
                            // Search & Filter
                            HStack {
                                HStack {
                                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                                    TextField("Search name, email...", text: $viewModel.searchQuery)
                                        .disableAutocorrection(true)
                                }
                                .padding(10)
                                .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
                                .cornerRadius(10)
                                
                                FilterConnectionMenu(title: "Company", selection: $viewModel.selectedCompanyFilter, options: viewModel.availableCompanies)
                            }
                            .padding(.horizontal)
                            
                            // List
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    if viewModel.filteredContacts.isEmpty {
                                        EmptyConnectionView(icon: "magnifyingglass", title: "No Results", message: "No contacts match your criteria.")
                                    } else {
                                        ForEach(viewModel.filteredContacts) { contact in
                                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                                PhysicalContactRow(contact: contact)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview("Light Mode") {
    ContactsTabView().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContactsTabView().preferredColorScheme(.dark)
}
