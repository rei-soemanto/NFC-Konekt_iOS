//
//  HomeTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct HomeTabView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    var textPrimary: Color { colorScheme == .dark ? .white : .twGray800 }
    
    var body: some View {
        NavigationView {
            ZStack {
                appBackground.ignoresSafeArea()
                
                Group {
                    switch viewModel.uiState {
                    case .loading:
                        ProgressView()
                            .scaleEffect(1.5)
                        
                    case .error(let message):
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                            Text("Error: \(message)")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                            Button("Retry") {
                                Task { await viewModel.loadData() }
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                        
                    case .success(let data):
                        ScrollView {
                            VStack(spacing: 24) {
                                // Header
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Dashboard Overview")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(textPrimary)
                                    Text("Welcome back! Here's what's happening with your network.")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.top, 16)
                                
                                // Profile Summary Card
                                ProfileSummaryCard(
                                    fullName: data.user.fullName,
                                    companyName: data.user.companyName ?? "Independent",
                                    avatarUrl: data.user.avatarUrl,
                                    onEditClick: {
                                        // Navigate to Profile View (Switch tab via bindings if needed)
                                    },
                                    onPreviewClick: {
                                        // Push to Preview Screen
                                    }
                                )
                                .padding(.horizontal)
                                
                                // Stats Column
                                VStack(spacing: 16) {
                                    DashboardStatCard(
                                        icon: "qrcode",
                                        iconBgColor: Color.blue.opacity(0.2),
                                        iconColor: .blue,
                                        value: "\(data.stats.scansMade)",
                                        title: "Scans Made",
                                        subtitle: "Cards you have scanned"
                                    )
                                    
                                    DashboardStatCard(
                                        icon: "iphone.radiowaves.left.and.right",
                                        iconBgColor: Color.twIndigo600.opacity(0.2),
                                        iconColor: .twIndigo600,
                                        value: "\(data.stats.scansReceived)",
                                        title: "Scans Received",
                                        subtitle: "People who scanned you"
                                    )
                                    
                                    DashboardStatCard(
                                        icon: "person.2.fill",
                                        iconBgColor: Color.twViolet600.opacity(0.2),
                                        iconColor: .twViolet600,
                                        value: "\(data.stats.friendsConnected)",
                                        title: "Friends Connected",
                                        subtitle: "Your network size"
                                    )
                                }
                                .padding(.horizontal)
                                
                                Spacer(minLength: 40)
                            }
                        }
                        .refreshable {
                            await viewModel.refreshData()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
