//
//  ConnectTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ConnectTabView: View {
    @StateObject private var viewModel = ConnectViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    
    var body: some View {
        NavigationView {
            ZStack {
                appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    Text("My Connections")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 16)
                    
                    if viewModel.isLocked {
                        LockedNetworkView()
                    } else {
                        VStack(spacing: 12) {
                            HStack {
                                HStack {
                                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                                    TextField("Search name, job...", text: $viewModel.searchQuery)
                                        .disableAutocorrection(true)
                                }
                                .padding(10)
                                .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
                                .cornerRadius(10)
                                
                                FilterConnectionMenu(title: "Industry", selection: $viewModel.selectedIndustry, options: viewModel.availableIndustries)
                            }
                            .padding(.horizontal)
                            
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    if viewModel.filteredConnections.isEmpty {
                                        EmptyConnectionView(icon: "person.2.slash", title: "No Connections", message: "Try adjusting your filters or search.")
                                    } else {
                                        ForEach(viewModel.filteredConnections) { conn in
                                            DigitalConnectionRow(connection: conn)
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
    ConnectTabView().preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ConnectTabView().preferredColorScheme(.dark)
}
