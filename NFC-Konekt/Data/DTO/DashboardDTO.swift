//
//  DashboardDTO.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

struct DashboardResponse: Codable {
    let user: DashboardUser
    let stats: DashboardStats
}

struct DashboardUser: Codable {
    let id: String
    let fullName: String
    let email: String
    let avatarUrl: String?
    let role: String
    let companyName: String?
    let planCategory: String
    let isCorporate: Bool
}

struct DashboardStats: Codable {
    let scansMade: Int
    let scansReceived: Int
    let friendsConnected: Int
    let conversionRate: String
}
