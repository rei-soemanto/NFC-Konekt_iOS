//
//  TeamDTO.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

struct AddTeamMemberRequest: Encodable {
    let fullName: String
    let email: String
    let jobTitle: String?
}

struct UpdateTeamMemberRequest: Encodable {
    let role: String?
    let isHidden: Bool?
    let jobTitle: String?
}

struct UpdateMemberRequest: Encodable {
    let jobTitle: String?
    let isCompanyPublic: Bool
}

struct TeamCardsResponse: Decodable {
    let success: Bool
}

struct TeamDataResponse: Decodable {
    let success: Bool
    let data: TeamDataPayload
}

struct TeamDataPayload: Decodable {
    let members: [TeamMemberDto]
    let stats: TeamStats
}

struct TeamStatsResponse: Decodable {
    let currentUsage: Int
    let maxUsage: Int
    let planName: String
    let members: [TeamMemberDto]
}

struct SingleMemberResponse: Decodable {
    let success: Bool
    let message: String?
    let data: TeamMemberDto
}

struct TeamStats: Decodable {
    let totalMembers: Int
    let activeCards: Int
}

struct TeamMemberDto: Codable, Identifiable {
    let id: String
    let fullName: String
    let email: String
    let jobTitle: String?
    let role: String?
    let avatarUrl: String?
    let isCompanyPublic: Bool?
}
