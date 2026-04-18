//
//  UserSubscriptionState.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation

enum UserSubscriptionState {
    case teamMember(managerName: String)
    case noSubscription
    case active
}

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

struct TransactionItem: Identifiable {
    let id: String
    let type: String
    let createdAt: Date
    let paymentId: String
    let shipmentStatus: String 
    let amount: Int
}
