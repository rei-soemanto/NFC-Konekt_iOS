//
//  HomeTabView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

// MARK: - Home Tab
struct HomeTabView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color {
        colorScheme == .dark ? .twGray950 : .twGray100
    }
    
    var cardBackground: Color {
        colorScheme == .dark ? .twGray900 : .white
    }
    
    var textPrimary: Color {
        colorScheme == .dark ? .white : .twGray800
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hello,")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(viewModel.userName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(textPrimary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    authViewModel.logout()
                                }
                            }) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.twIndigo600)
                                    .padding(10)
                                    .background(cardBackground)
                                    .clipShape(Circle())
                                    .shadow(color: colorScheme == .dark ? .twIndigo600.opacity(0.1) : .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Primary NFC Card Display
                        if let primaryCard = viewModel.activeCards.first(where: { $0.isPrimary }) {
                            DigitalCardView(card: primaryCard, userName: viewModel.userName, role: viewModel.role, company: viewModel.company)
                                .padding(.horizontal)
                        }
                        
                        // Quick Actions
                        HStack(spacing: 16) {
                            QuickActionButton(icon: "wave.3.right", title: "Write NFC", color: .twIndigo600, cardBackground: cardBackground)
                            QuickActionButton(icon: "qrcode.viewfinder", title: "Scan QR", color: .twViolet600, cardBackground: cardBackground)
                            QuickActionButton(icon: "square.and.arrow.up", title: "Share ID", color: .twIndigo600, cardBackground: cardBackground)
                        }
                        .padding(.horizontal)
                        
                        // Recent Activity / Other Cards
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Other Cards")
                                .font(.headline)
                                .foregroundColor(textPrimary)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.activeCards.filter { !$0.isPrimary }) { card in
                                HStack {
                                    Image(systemName: "creditcard.fill")
                                        .foregroundColor(.twViolet600)
                                        .padding()
                                        .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(card.title)
                                            .fontWeight(.semibold)
                                            .foregroundColor(textPrimary)
                                        Text(card.subtitle)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                .padding()
                                .background(cardBackground)
                                .cornerRadius(16)
                                .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.03), radius: 10, x: 0, y: 5)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 8)
                        
                        Spacer(minLength: 40)
                    }
                }
                .refreshable {
                    await viewModel.refreshData()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview("Light Mode") {
    HomeTabView(
        viewModel: DashboardViewModel(),
        authViewModel: AuthViewModel()
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    HomeTabView(
        viewModel: DashboardViewModel(),
        authViewModel: AuthViewModel()
    )
    .preferredColorScheme(.dark)
}
