//
//  Person.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
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

struct HistoryItem: Identifiable {
    let id: String
    let scannedAt: Date
    let person: Person
    var isConnected: Bool
}

enum HistoryTab {
    case outbound
    case inbound  
}
