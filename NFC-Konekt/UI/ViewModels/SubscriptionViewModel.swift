//
//  UserSubscriptionState.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine
import SwiftUI

enum UserSubscriptionState {
    case active, noSubscription, teamMember(String)
}

@MainActor
class SubscriptionViewModel: ObservableObject {
    @Published var viewState: UserSubscriptionState = .active
    @Published var isLoading: Bool = false
    @Published var isActionLoading: Bool = false
    
    @Published var subData: SubscriptionStatusData?
    @Published var transactions: [TransactionItem] = []
    @Published var errorMessage: String?
    
    @Published var showCancelModal: Bool = false
    @Published var showUpgradeSheet: Bool = false
    @Published var showCorporateUpgradeWarning: Bool = false
    @Published var paymentUrl: String? = nil
    
    private let repository: SubscriptionRepository
    
    init(repository: SubscriptionRepository) {
        self.repository = repository
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await repository.getSubscriptionStatus()
            self.subData = data
            
            switch data.status {
            case "FREE": self.viewState = .noSubscription
            case "TEAM_MEMBER": self.viewState = .teamMember("Your Manager")
            default: self.viewState = .active
            }
            
            if let txs = data.transactions {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                
                self.transactions = txs.map { dto in
                    let parsedDate = formatter.date(from: dto.createdAt)
                        ?? ISO8601DateFormatter().date(from: dto.createdAt)
                        ?? Date()
                    
                    return TransactionItem(
                        id: dto.id,
                        type: dto.type,
                        createdAt: parsedDate,
                        paymentId: dto.paymentId,
                        shipmentStatus: dto.shipmentStatus ?? "UNKNOWN",
                        amount: dto.amount
                    )
                }
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.viewState = .noSubscription
        }
        isLoading = false
    }
    
    func cancelSubscription() async {
        isActionLoading = true
        do {
            try await repository.cancelSubscription()
            showCancelModal = false
            await loadData()
        } catch { errorMessage = error.localizedDescription }
        isActionLoading = false
    }
    
    func markShipmentReceived() async {
        isActionLoading = true
        do {
            try await repository.markShipmentReceived()
            await loadData()
        } catch { errorMessage = error.localizedDescription }
        isActionLoading = false
    }
    
    func initiateRenewal() async {
        guard let planId = subData?.planId else { return }
        isActionLoading = true
        do {
            let request = MobileCheckoutRequest(planId: planId, mode: "RENEW", duration: nil)
            let response = try await repository.initiateMobileCheckout(request: request)
            if response.success, let url = response.redirectUrl {
                self.paymentUrl = url
            } else {
                errorMessage = response.message ?? "Failed to load payment."
            }
        } catch { errorMessage = error.localizedDescription }
        isActionLoading = false
    }
    
    func onUpgradeClicked() {
        let isCorporate = subData?.planName.localizedCaseInsensitiveContains("Corporate") == true
        if isCorporate { showCorporateUpgradeWarning = true }
        else { showUpgradeSheet = true }
    }
    
    func initiateUpgrade(duration: String) async {
        guard let planId = subData?.planId else { return }
        isActionLoading = true
        showUpgradeSheet = false
        do {
            let request = MobileCheckoutRequest(planId: planId, mode: "UPGRADE", duration: duration)
            let response = try await repository.initiateMobileCheckout(request: request)
            if response.success, let url = response.redirectUrl {
                self.paymentUrl = url
            } else {
                errorMessage = response.message ?? "Failed to load payment."
            }
        } catch { errorMessage = error.localizedDescription }
        isActionLoading = false
    }
    
    func closePaymentWebView() {
        self.paymentUrl = nil
        Task { await loadData() } 
    }
    
    func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    func formatDateString(_ isoString: String?) -> String {
        guard let isoString = isoString else { return "N/A" }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: isoString) ?? ISO8601DateFormatter().date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium 
            return displayFormatter.string(from: date)
        }
        return isoString
    }
}
