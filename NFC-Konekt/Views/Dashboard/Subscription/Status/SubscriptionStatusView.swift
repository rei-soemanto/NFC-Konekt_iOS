//
//  SubscriptionStatusView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct SubscriptionStatusView: View {
    @StateObject private var viewModel = SubscriptionViewModel()
    
    var body: some View {
        SubscriptionStatusViewContent(viewModel: viewModel)
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
    NavigationView {
        SubscriptionStatusViewContent(viewModel: SubscriptionViewModel())
    }
    .preferredColorScheme(.light)
}

#Preview("Team Member State") {
    let teamVM = SubscriptionViewModel()
    teamVM.viewState = .teamMember(managerName: "Antonius Pramudiya")
    
    return NavigationView {
        SubscriptionStatusViewContent(viewModel: teamVM)
    }
}

#Preview("No Plan State - Dark") {
    let emptyVM = SubscriptionViewModel()
    emptyVM.viewState = .noSubscription
    
    return NavigationView {
        SubscriptionStatusViewContent(viewModel: emptyVM)
    }
    .preferredColorScheme(.dark)
}
