//
//  CancelSubscriptionModal.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct CancelSubscriptionModal: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle().fill(Color.red.opacity(0.1)).frame(width: 64, height: 64)
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red).font(.title)
                }
                
                VStack(spacing: 8) {
                    Text("Cancel Subscription?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                    Text("Your subscription will remain active until \(viewModel.subData?.endDate ?? ""). After that, your features will be locked immediately.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                HStack(spacing: 12) {
                    Button(action: { withAnimation { viewModel.showCancelModal = false } }) {
                        Text("Keep It")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(colorScheme == .dark ? Color.twGray800 : Color.gray.opacity(0.1))
                            .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { Task { await viewModel.cancelSubscription() } }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView().scaleEffect(0.8)
                            } else {
                                Text("Yes, Cancel")
                            }
                        }
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .padding(24)
            .background(colorScheme == .dark ? Color.twGray900 : .white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(24)
            .transition(.scale.combined(with: .opacity))
        }
        .zIndex(1)
    }
}

#Preview("Light Mode") {
    let container = DIContainer()
    let viewModel = SubscriptionViewModel(repository: container.subscriptionRepository)
    
    viewModel.subData = SubInfo(
        planId: "mock_1",
        status: "ACTIVE",
        startDate: "18 April 2025",
        endDate: "18 April 2026",
        expansionPacks: 2,
        planName: "Corporate Pro",
        planPrice: 1500000,
        planDurationLabel: "1 Year",
        expansionPrice: 500000,
        currency: "IDR",
        nextBillAmount: 2500000,
        nextBillDate: "18 April 2026",
        remainingDays: 14,
        progressPercentage: 96.0
    )
    
    return ZStack {
        Color.twGray100.ignoresSafeArea()
        CancelSubscriptionModal(viewModel: viewModel)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    let viewModel = SubscriptionViewModel(repository: container.subscriptionRepository)
    
    viewModel.subData = SubInfo(
        planId: "mock_1",
        status: "ACTIVE",
        startDate: "18 April 2025",
        endDate: "18 April 2026",
        expansionPacks: 2,
        planName: "Corporate Pro",
        planPrice: 1500000,
        planDurationLabel: "1 Year",
        expansionPrice: 500000,
        currency: "IDR",
        nextBillAmount: 2500000,
        nextBillDate: "18 April 2026",
        remainingDays: 14,
        progressPercentage: 96.0
    )
    
    return ZStack {
        Color.twGray950.ignoresSafeArea()
        CancelSubscriptionModal(viewModel: viewModel)
    }
    .preferredColorScheme(.dark)
}
