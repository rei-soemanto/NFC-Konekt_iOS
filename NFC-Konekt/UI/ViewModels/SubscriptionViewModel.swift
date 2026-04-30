//
//  UserSubscriptionState.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SubscriptionViewModel: ObservableObject {
    @Published var viewState: UserSubscriptionState = .active
    @Published var isLoading: Bool = false
    
    @Published var subData: SubInfo?
    @Published var activeShipmentStatus: String?
    @Published var activeShipmentTracking: String?
    @Published var transactions: [TransactionItem] = []
    
    @Published var showCancelModal: Bool = false
    
    private let repository: SubscriptionRepository
    
    init(repository: SubscriptionRepository) {
        self.repository = repository
    }
    
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await repository.getSubscriptionStatus()
            self.subData = SubInfo(dto: data)
            
            if let shipment = data.shipment {
                self.activeShipmentStatus = shipment.status
                self.activeShipmentTracking = shipment.trackingLink
            } else {
                self.activeShipmentStatus = nil
            }
            
            if let txs = data.transactions {
                self.transactions = txs.map { TransactionItem(dto: $0) }
            }
            
        } catch {
            print("Error loading subscription: \(error)")
            self.viewState = .noSubscription
        }
    }
    
    func cancelSubscription() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await repository.cancelSubscription()
            subData?.status = "CANCELED"
            showCancelModal = false
        } catch {
            print("Failed to cancel: \(error)")
        }
    }
    
    func markShipmentReceived() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await repository.markShipmentReceived()
            activeShipmentStatus = "ARRIVED"
        } catch {
            print("Failed to mark shipment: \(error)")
        }
    }
    
    func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
