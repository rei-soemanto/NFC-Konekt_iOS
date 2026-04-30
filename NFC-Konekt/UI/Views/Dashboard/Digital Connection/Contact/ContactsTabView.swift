//
//  ContactsTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ContactsTabView: View {
    @ObservedObject var viewModel: ContactsViewModel
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
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    // 2. FIXED: Handle Loading and Error States
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Spacer()
                    } else if let errorMessage = viewModel.errorMessage {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                            Button("Retry") {
                                Task { await viewModel.loadContacts() }
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                        Spacer()
                    } else if viewModel.contacts.isEmpty {
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
                            
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    if viewModel.filteredContacts.isEmpty {
                                        EmptyConnectionView(icon: "magnifyingglass", title: "No Results", message: "No contacts match your criteria.")
                                            .padding(.top, 40)
                                    } else {
                                        ForEach(viewModel.filteredContacts, id: \.id) { contact in
                                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                                PhysicalContactRow(contact: contact)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                                .padding()
                            }
                            .refreshable {
                                await viewModel.loadContacts()
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            // Automatically fetch data when the view appears if it's empty
            if viewModel.contacts.isEmpty {
                await viewModel.loadContacts()
            }
        }
    }
}

#Preview("Light Mode") {
    let container = DIContainer()
    return ContactsTabView(viewModel: ContactsViewModel(repository: container.contactRepository))
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    return ContactsTabView(viewModel: ContactsViewModel(repository: container.contactRepository))
        .preferredColorScheme(.dark)
}
