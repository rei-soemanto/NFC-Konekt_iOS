//
//  Person.swift
//  NFC-Konekt
//

import Foundation

struct Person: Identifiable {
    let id: String
    let fullName: String
    let email: String
    let jobTitle: String?
    let companyName: String?
    let avatarUrl: String?
    
    var initials: String {
        let components = fullName.components(separatedBy: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        }
        return String(fullName.prefix(1)).uppercased()
    }
}

extension Person {
    init(dto: HistoryPersonDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.email = dto.email
        self.jobTitle = dto.jobTitle
        self.companyName = dto.companyName
        self.avatarUrl = dto.avatarUrl
    }
}

struct HistoryItem: Identifiable {
    let id: String
    let scannedAt: Date
    let person: Person
    var isConnected: Bool
}

extension HistoryItem {
    init(dto: HistoryItemDto) {
        self.id = dto.id
        self.scannedAt = Formatter.iso8601.date(from: dto.scannedAt) ?? Date()
        self.isConnected = dto.isConnected
        self.person = Person(dto: dto.person)
    }
}
