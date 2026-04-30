//
//  SubscriptionDTO.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

struct MobileCheckoutRequest: Encodable {
    let planId: String
    let mode: String
    let duration: String?
}

struct MobileCheckoutResponse: Decodable {
    let success: Bool
    let snapToken: String?
    let redirectUrl: String?
    let orderId: String?
    let message: String?
}

struct SubscriptionStatusResponse: Decodable {
    let success: Bool
    let data: SubscriptionStatusData
}

struct SubscriptionStatusData: Decodable {
    let status: String
    let planId: String?
    let planName: String
    let planPrice: Int?
    let planDurationLabel: String?
    let expansionPacks: Int?
    let expansionPrice: Int?
    let currency: String?
    let startDate: String?
    let endDate: String
    let daysLeft: Int
    let progressPercentage: Double?
    let nextBillAmount: Int?
    let nextBillDate: String?
    let shipment: ShipmentData?
    let transactions: [TransactionDto]?
}

struct ShipmentData: Decodable {
    let transactionId: String
    let status: String
    let trackingLink: String?
}

struct TransactionDto: Decodable, Identifiable {
    let id: String
    let type: String
    let status: String
    let amount: Int
    let currency: String
    let paymentId: String
    let shipmentStatus: String?
    let trackingLink: String?
    let expansionPacks: Int
    let planName: String?
    let discountApplied: Int
    let createdAt: String
}

struct SubscriptionDto: Codable {
    let plan: PlanDto?
}

struct PlanDto: Codable {
    let category: String
}
