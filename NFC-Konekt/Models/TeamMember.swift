//
//  TeamMember.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

struct TeamMember: Identifiable {
    let id: String
    var fullName: String
    var email: String
    var jobTitle: String?
    var isCompanyPublic: Bool
    let avatarUrl: String?
}
