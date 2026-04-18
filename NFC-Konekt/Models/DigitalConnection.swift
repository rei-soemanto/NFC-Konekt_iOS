//
//  DigitalConnection.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation

struct DigitalConnection: Identifiable {
    let id: String
    let fullName: String
    let email: String
    let avatarUrl: String?
    let jobTitle: String?
    let companyName: String?
    let companyScope: String?
    let companySpeciality: String?
    let companyLogoUrl: String?
}

struct PhysicalContact: Identifiable {
    let id: String
    let name: String
    let email: String?
    let phone: String?
    let company: String?
    let website: String?
    let jobTitle: String?
    let notes: String?
    let isRegisteredMember: Bool // Link to user profile if available
}

enum NetworkTab {
    case connections
    case contacts
}
