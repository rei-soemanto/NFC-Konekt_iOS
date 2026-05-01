//
//  SubscriptionStatusView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct SubscriptionStatusView: View {
    @StateObject private var viewModel: SubscriptionViewModel
    
    init(repository: SubscriptionRepository) {
        _viewModel = StateObject(wrappedValue: SubscriptionViewModel(repository: repository))
    }
    
    var body: some View {
        SubscriptionStatusViewContent(viewModel: viewModel)
            .task {
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
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        if let error = viewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        switch viewModel.viewState {
                        case .teamMember(let managerName):
                            TeamMemberPlaceholder(managerName: managerName)
                        case .noSubscription:
                            NoSubscriptionPlaceholder()
                        case .active:
                            if let sub = viewModel.subData {
                                SubscriptionInfoCard(viewModel: viewModel, sub: sub)
                                
                                if let shipStatus = sub.shipment?.status {
                                    ShipmentTrackerCard(viewModel: viewModel, status: shipStatus)
                                }
                                
                                TransactionHistoryCard(viewModel: viewModel)
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            
            if viewModel.showCancelModal {
                CancelSubscriptionModal(viewModel: viewModel)
            }
            
            if viewModel.isActionLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView().padding().background(Color(.systemBackground)).cornerRadius(12)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showUpgradeSheet) {
            UpgradeDurationSheet(viewModel: viewModel)
                .presentationDetents([.height(300)])
        }
        .alert(isPresented: $viewModel.showCorporateUpgradeWarning) {
            Alert(
                title: Text("Web Portal Required"),
                message: Text("Corporate plan expansions and upgrades require team configuration. Please log in to the web portal to manage your corporate account."),
                dismissButton: .default(Text("Understood"))
            )
        }
        .fullScreenCover(isPresented: Binding(
            get: { viewModel.paymentUrl != nil },
            set: { if !$0 { viewModel.closePaymentWebView() } }
        )) {
            if let url = viewModel.paymentUrl {
                PaymentWebViewContainer(urlString: url, onClose: { viewModel.closePaymentWebView() })
            }
        }
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
