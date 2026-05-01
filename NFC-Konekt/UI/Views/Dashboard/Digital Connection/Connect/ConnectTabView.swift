//
//  ConnectTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ConnectTabView: View {
    @ObservedObject var viewModel: ConnectViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if viewModel.isScanningActive || viewModel.scannedUser != nil || viewModel.isFetchingProfile {
                        ScannerOverlayView(viewModel: viewModel)
                    } else if viewModel.isLocked {
                        LockedNetworkView()
                    } else {
                        // Main Connections List
                        VStack(spacing: 0) {
                            Text("Digital Network").font(.title2).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding()
                            
                            HStack {
                                HStack {
                                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                                    TextField("Search network...", text: $viewModel.searchQuery).disableAutocorrection(true)
                                }
                                .padding(10).background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6)).cornerRadius(10)
                                
                                FilterConnectionMenu(title: "Industry", selection: $viewModel.selectedIndustry, options: viewModel.availableIndustries)
                            }.padding(.horizontal)
                            
                            if viewModel.isLoadingList {
                                Spacer()
                                ProgressView()
                                Spacer()
                            } else {
                                ScrollView {
                                    LazyVStack(spacing: 12) {
                                        if viewModel.filteredConnections.isEmpty {
                                            EmptyConnectionView(icon: "magnifyingglass", title: "No Results", message: "Try adjusting your filters or search.").padding(.top, 40)
                                        } else {
                                            ForEach(viewModel.filteredConnections) { conn in
                                                DigitalConnectionRow(connection: conn)
                                            }
                                        }
                                    }.padding()
                                }
                                .refreshable { await viewModel.loadConnections() }
                            }
                        }
                    }
                }
                
                if !viewModel.isScanningActive && viewModel.scannedUser == nil && !viewModel.isLocked {
                    Button(action: { viewModel.startScanning() }) {
                        HStack {
                            Image(systemName: "wave.3.right")
                            Text("Scan Card").fontWeight(.bold)
                        }
                        .padding(.horizontal, 20).padding(.vertical, 16)
                        .background(Color.twIndigo600).foregroundColor(.white).cornerRadius(16)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            if viewModel.connections.isEmpty {
                await viewModel.loadConnections()
            }
        }
    }
}

#Preview("Light Mode") {
    let container = DIContainer()
    return ConnectTabView(
        viewModel: ConnectViewModel(
            connectRepository: container.connectRepository,
            subscriptionRepository: container.subscriptionRepository
        )
    ).preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    return ConnectTabView(
        viewModel: ConnectViewModel(
            connectRepository: container.connectRepository,
            subscriptionRepository: container.subscriptionRepository
        )
    ).preferredColorScheme(.dark)
}
