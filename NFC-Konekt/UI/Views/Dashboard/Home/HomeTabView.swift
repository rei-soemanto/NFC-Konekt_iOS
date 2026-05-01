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
    @EnvironmentObject var container: DIContainer
    
    @State private var showDigitalCardPreview = false
    @State private var navigateToProfile = false
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    var textPrimary: Color { colorScheme == .dark ? .white : .twGray800 }
    
    var body: some View {
        NavigationView {
            ZStack {
                appBackground.ignoresSafeArea()
                
                NavigationLink(
                    destination: AccountSettingsView(repository: container.profileRepository)
                        .environmentObject(authViewModel)
                        .environmentObject(container),
                    isActive: $navigateToProfile
                ) {
                    EmptyView()
                }
                
                mainContent
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showDigitalCardPreview) {
                if case let .success(data) = viewModel.uiState {
                    DigitalCardPreviewSheet(
                        repository: container.profileRepository,
                        dashboardUser: data.user
                    )
                    .presentationDetents([.fraction(0.85), .large])
                    .presentationDragIndicator(.visible)
                } else {
                    Color(red: 15/255, green: 23/255, blue: 42/255).ignoresSafeArea()
                }
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.uiState {
        case .loading:
            ProgressView().scaleEffect(1.5)
            
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
                    
                    Button(action: {
                        showDigitalCardPreview = true
                    }) {
                        ProfileSummaryCard(
                            fullName: data.user.fullName,
                            companyName: data.user.companyName ?? "Independent",
                            avatarUrl: data.user.avatarUrl,
                            onEditClick: {
                                navigateToProfile = true
                            },
                            onPreviewClick: {
                                showDigitalCardPreview = true
                            }
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        DashboardStatCard(
                            icon: "qrcode", iconBgColor: Color.blue.opacity(0.2), iconColor: .blue,
                            value: "\(data.stats.scansMade)", title: "Scans Made", subtitle: "Cards you have scanned"
                        )
                        DashboardStatCard(
                            icon: "iphone.radiowaves.left.and.right", iconBgColor: Color.twIndigo600.opacity(0.2), iconColor: .twIndigo600,
                            value: "\(data.stats.scansReceived)", title: "Scans Received", subtitle: "People who scanned you"
                        )
                        DashboardStatCard(
                            icon: "person.2.fill", iconBgColor: Color.twViolet600.opacity(0.2), iconColor: .twViolet600,
                            value: "\(data.stats.friendsConnected)", title: "Friends Connected", subtitle: "Your network size"
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

struct DigitalCardPreviewSheet: View {
    @StateObject private var profileViewModel: AccountViewModel
    let dashboardUser: DashboardUser
    
    @State private var didLoadProfile = false
    
    init(repository: ProfileRepository, dashboardUser: DashboardUser) {
        _profileViewModel = StateObject(wrappedValue: AccountViewModel(repository: repository))
        self.dashboardUser = dashboardUser
    }
    
    var body: some View {
        ZStack {
            Color(red: 15/255, green: 23/255, blue: 42/255).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                DigitalConnectCard(
                    fullName: didLoadProfile ? profileViewModel.fullName : dashboardUser.fullName,
                    companyName: didLoadProfile ? (profileViewModel.companyName.isEmpty ? nil : profileViewModel.companyName) : dashboardUser.companyName,
                    website: didLoadProfile ? (profileViewModel.companyWebsite.isEmpty ? nil : profileViewModel.companyWebsite) : dashboardUser.companyWebsite,
                    email: didLoadProfile ? profileViewModel.email : (dashboardUser.email ?? ""),
                    avatarUrl: didLoadProfile ? profileViewModel.avatarUrl : dashboardUser.avatarUrl,
                    socialLinks: didLoadProfile ? profileViewModel.socialLinks : (dashboardUser.socialLinks ?? []),
                    connectionStatus: .selfUser,
                    onConnectClick: {},
                    isPreviewMode: true
                )
                .padding(16)
                .padding(.top, 24)
            }
        }
        .task {
            await profileViewModel.loadProfile()
            didLoadProfile = true
        }
    }
}
