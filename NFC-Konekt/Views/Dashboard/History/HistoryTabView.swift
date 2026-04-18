//
//  HistoryTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct HistoryTabView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color {
        colorScheme == .dark ? .twGray950 : .twGray100
    }
    var cardBackground: Color {
        colorScheme == .dark ? .twGray900 : .white
    }
    
    var currentData: [HistoryItem] {
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
                    
                    // 2. Custom Tabs (Matching web border-bottom style)
                    HStack(spacing: 0) {
                        TabButton(title: "Scanned By Me", icon: "qrcode.viewfinder", isActive: viewModel.activeTab == .outbound) {
                            withAnimation { viewModel.activeTab = .outbound }
                        }
                        TabButton(title: "Users Scanning Me", icon: "eye.fill", isActive: viewModel.activeTab == .inbound) {
                            withAnimation { viewModel.activeTab = .inbound }
                        }
                    }
                    .background(cardBackground)
                    .overlay(Divider(), alignment: .bottom)
                    
                    // 3. Content Area
                    if currentData.isEmpty {
                        EmptyHistoryView(tab: viewModel.activeTab)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(currentData) { item in
                                    HistoryRowView(
                                        item: item,
                                        hasSubscription: viewModel.hasSubscription,
                                        onConnect: {
                                            Task { await viewModel.connect(with: item.person.id) }
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    HistoryTabView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    HistoryTabView()
        .preferredColorScheme(.dark)
}
