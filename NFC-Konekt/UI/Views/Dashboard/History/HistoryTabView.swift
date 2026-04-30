//
//  HistoryTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct HistoryTabView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color {
        colorScheme == .dark ? .twGray950 : .twGray100
    }
    var cardBackground: Color {
        colorScheme == .dark ? .twGray900 : .white
    }
    
    var currentData: [HistoryItemDto] {
        viewModel.activeTab == .outbound ? viewModel.outboundList : viewModel.inboundList
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 1. Header
                    Text("History")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 16)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    // 2. Custom Tabs
                    HStack(spacing: 0) {
                        TabButton(title: "Scanned By Me", icon: "qrcode.viewfinder", isActive: viewModel.activeTab == .outbound) {
                            withAnimation { viewModel.setTab(.outbound) }
                        }
                        TabButton(title: "Users Scanning Me", icon: "eye.fill", isActive: viewModel.activeTab == .inbound) {
                            withAnimation { viewModel.setTab(.inbound) }
                        }
                    }
                    .background(cardBackground)
                    .overlay(Divider(), alignment: .bottom)
                    
                    // 3. Content Area with loading/error state handling
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
                                Task { await viewModel.loadData() }
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                        Spacer()
                    } else if currentData.isEmpty {
                        EmptyHistoryView(tab: viewModel.activeTab)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(currentData, id: \.id) { item in
                                    HistoryRowView(
                                        item: item,
                                        hasSubscription: viewModel.hasSubscription,
                                        onConnect: {
                                            Task { await viewModel.connect(personId: item.person.id, slug: item.person.slug) }
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                        .refreshable {
                            await viewModel.loadData()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            if viewModel.outboundList.isEmpty && viewModel.inboundList.isEmpty {
                await viewModel.loadData()
            }
        }
    }
}

#Preview("Light Mode") {
    let container = DIContainer()
    return HistoryTabView(
        viewModel: HistoryViewModel(
            historyRepository: container.historyRepository,
            connectRepository: container.connectRepository,
            subscriptionRepository: container.subscriptionRepository
        )
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    return HistoryTabView(
        viewModel: HistoryViewModel(
            historyRepository: container.historyRepository,
            connectRepository: container.connectRepository,
            subscriptionRepository: container.subscriptionRepository
        )
    )
    .preferredColorScheme(.dark)
}
