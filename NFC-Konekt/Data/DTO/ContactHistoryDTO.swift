//
//  ContactHistoryDTO.swift.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

struct AddContactRequest: Encodable {
    let name: String?
    let phone: String?
    let slug: String?
}

struct SlugRequest: Encodable {
    let slug: String
}

struct ErrorResponse: Decodable {
    let error: String
}

struct DigitalConnectionDto: Decodable {
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

struct ContactBaseResponse: Decodable {
    let success: Bool
    let data: [PhysicalContactDto]
}

struct PhysicalContactDto: Decodable, Identifiable {
    let id: String
    let name: String
    let email: String?
    let phone: String?
    let company: String?
    let website: String?
    let jobTitle: String?
    let notes: String?
    let isRegisteredMember: Bool
}

struct HistoryResponse: Decodable {
    let success: Bool
    let data: HistoryData?
}

struct HistoryData: Decodable {
    let scannedByMe: [HistoryItemDto]?
    let scannedByOthers: [HistoryItemDto]?
}

struct HistoryItemDto: Decodable {
    let id: String
    let scannedAt: String
    var isConnected: Bool
    let person: HistoryPersonDto
}

struct HistoryPersonDto: Decodable {
    let id: String
    let fullName: String
    let email: String
    let jobTitle: String?
    let companyName: String?
    let avatarUrl: String?
    let slug: String?
}
