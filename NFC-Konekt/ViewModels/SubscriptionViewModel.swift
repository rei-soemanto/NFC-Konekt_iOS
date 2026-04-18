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
    
    // Data
    @Published var subData: SubInfo?
    @Published var activeShipmentStatus: String? = "SHIPPING" // nil, "PROCESSING", "SHIPPING", "ARRIVED"
    @Published var activeShipmentTracking: String? = "https://track.example.com/123"
    @Published var transactions: [TransactionItem] = []
    
    // Modals
    @Published var showCancelModal: Bool = false
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        subData = SubInfo(
            planId: "plan_123",
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
        
        transactions = [
            TransactionItem(id: "tx1", type: "EXPANSION", createdAt: Date().addingTimeInterval(-86400 * 5), paymentId: "PAY-987", shipmentStatus: "SHIPPING", amount: 500000),
            TransactionItem(id: "tx2", type: "NEW", createdAt: Date().addingTimeInterval(-86400 * 350), paymentId: "PAY-123", shipmentStatus: "ARRIVED", amount: 2000000)
        ]
    }
    
    func cancelSubscription() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        subData?.status = "CANCELED"
        isLoading = false
        showCancelModal = false
    }
    
    func markShipmentReceived() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        activeShipmentStatus = "ARRIVED"
        isLoading = false
    }
    
    // Formatter for Currency
    func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
