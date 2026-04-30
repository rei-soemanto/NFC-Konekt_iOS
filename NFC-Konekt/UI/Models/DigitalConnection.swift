//
//  DigitalConnection.swift
//  NFC-Konekt
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

extension DigitalConnection {
    init(dto: DigitalConnectionDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.email = dto.email
        self.avatarUrl = dto.avatarUrl
        self.jobTitle = dto.jobTitle
        self.companyName = dto.companyName
        self.companyScope = dto.companyScope
        self.companySpeciality = dto.companySpeciality
        self.companyLogoUrl = dto.companyLogoUrl
    }
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
    let isRegisteredMember: Bool
}

extension PhysicalContact {
    init(dto: PhysicalContactDto) {
        self.id = dto.id
        self.name = dto.name
        self.email = dto.email
        self.phone = dto.phone
        self.company = dto.company
        self.website = dto.website
        self.jobTitle = dto.jobTitle
        self.notes = dto.notes
        self.isRegisteredMember = dto.isRegisteredMember
    }
}

enum NetworkTab {
    case connections
    case contacts
}
