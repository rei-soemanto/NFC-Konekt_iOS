//
//  SubscriptionStatusView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct SubscriptionStatusView: View {
    @StateObject private var viewModel: SubscriptionViewModel
    
    // Custom initializer to inject the repository into the StateObject
    init(repository: SubscriptionRepository) {
        _viewModel = StateObject(wrappedValue: SubscriptionViewModel(repository: repository))
    }
    
    var body: some View {
        SubscriptionStatusViewContent(viewModel: viewModel)
            .task {
                // Fetch real data from the backend when the view appears
                await viewModel.loadData()
            }
    }
}

struct SubscriptionStatusViewContent: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var body: some View {
        ZStack {
            appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    // Display different UI based on the live subscription state
                    switch viewModel.viewState {
                    case .teamMember(let managerName):
                        TeamMemberPlaceholder(managerName: managerName)
                    case .noSubscription:
                        NoSubscriptionPlaceholder()
                    case .active:
                        if let sub = viewModel.subData {
                            SubscriptionInfoCard(viewModel: viewModel, sub: sub)
                            
                            if let shipStatus = viewModel.activeShipmentStatus {
                                ShipmentTrackerCard(viewModel: viewModel, status: shipStatus)
                            }
                            
                            // Ensure TransactionHistoryCard also accepts the view model properly if it needs it!
                            TransactionHistoryCard(viewModel: viewModel)
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            
            if viewModel.showCancelModal {
                CancelSubscriptionModal(viewModel: viewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Subscription Status")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(primaryText)
            Text("Manage your billing, plan details, and shipments.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#Preview("Active Plan - Light") {
    let container = DIContainer()
    let vm = SubscriptionViewModel(repository: container.subscriptionRepository)
    
    vm.subData = SubInfo(
        planId: "p1", status: "ACTIVE", startDate: "2024-01-01", endDate: "2025-01-01",
        expansionPacks: 1, planName: "Pro Plan", planPrice: 100000,
        planDurationLabel: "Yearly", expansionPrice: 20000, currency: "USD",
        nextBillAmount: 120000, nextBillDate: "2025-01-01", remainingDays: 250,
        progressPercentage: 30.0
    )
    
    return NavigationView {
        SubscriptionStatusViewContent(viewModel: vm)
    }
    .environmentObject(container)
    .preferredColorScheme(.light)
}

#Preview("Team Member State") {
    let container = DIContainer()
    let teamVM = SubscriptionViewModel(repository: container.subscriptionRepository)
    teamVM.viewState = .teamMember(managerName: "Antonius Pramudiya")
    
    return NavigationView {
        SubscriptionStatusViewContent(viewModel: teamVM)
    }
    .environmentObject(container)
}

#Preview("No Plan State - Dark") {
    let container = DIContainer()
    let emptyVM = SubscriptionViewModel(repository: container.subscriptionRepository)
    emptyVM.viewState = .noSubscription
    
    return NavigationView {
        SubscriptionStatusViewContent(viewModel: emptyVM)
    }
    .environmentObject(container)
    .preferredColorScheme(.dark)
}
