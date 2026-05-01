//
//  UserSubscriptionState.swift
//  NFC-Konekt
//

import Foundation

struct SubInfo {
    var planId: String
    var status: String
    var startDate: String
    var endDate: String
    var expansionPacks: Int
    var planName: String
    var planPrice: Int
    var planDurationLabel: String
    var expansionPrice: Int
    var currency: String
    var nextBillAmount: Int
    var nextBillDate: String
    var remainingDays: Int
    var progressPercentage: Double
}

extension SubInfo {
    init(dto: SubscriptionStatusData) {
        self.planId = dto.planId ?? ""
        self.status = dto.status
        self.startDate = dto.startDate ?? ""
        self.endDate = dto.endDate
        self.expansionPacks = dto.expansionPacks ?? 0
        self.planName = dto.planName
        self.planPrice = dto.planPrice ?? 0
        self.planDurationLabel = dto.planDurationLabel ?? "Month"
        self.expansionPrice = dto.expansionPrice ?? 0
        self.currency = dto.currency ?? "IDR"
        self.nextBillAmount = dto.nextBillAmount ?? 0
        self.nextBillDate = dto.nextBillDate ?? ""
        self.remainingDays = dto.daysLeft
        self.progressPercentage = dto.progressPercentage ?? 0.0
    }
}

struct TransactionItem: Identifiable {
    let id: String
    let type: String
    let createdAt: Date
    let paymentId: String
    let shipmentStatus: String
    let amount: Int
}

extension TransactionItem {
    init(dto: TransactionDto) {
        self.id = dto.id
        self.type = dto.type
        self.createdAt = Formatter.iso8601.date(from: dto.createdAt) ?? Date()
        self.paymentId = dto.paymentId
        self.shipmentStatus = dto.shipmentStatus ?? "PENDING"
        self.amount = dto.amount
    }
}
