//
//  TeamMember.swift
//  NFC-Konekt
//

struct TeamMember: Identifiable {
    let id: String
    var fullName: String
    var email: String
    var jobTitle: String?
    var isCompanyPublic: Bool
    let avatarUrl: String?
}

extension TeamMember {
    init(dto: TeamMemberDto) {
        self.id = dto.id
        self.fullName = dto.fullName
        self.email = dto.email
        self.jobTitle = dto.jobTitle
        // Fallback to true if backend doesn't provide it
        self.isCompanyPublic = dto.isCompanyPublic ?? true
        self.avatarUrl = dto.avatarUrl
    }
}
