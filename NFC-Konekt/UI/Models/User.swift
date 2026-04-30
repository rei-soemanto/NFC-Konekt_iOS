//
//  User.swift
//  NFC-Konekt
//

import Foundation

struct User: Identifiable {
    let id: String
    var name: String?
    let email: String
}

extension User {
    init(authDto: AuthUser) {
        self.id = authDto.id
        self.name = authDto.fullName
        self.email = authDto.email
    }
    
    init(dashboardDto: DashboardUser) {
        self.id = dashboardDto.id
        self.name = dashboardDto.fullName
        self.email = dashboardDto.email
    }
}

enum AuthState {
    case unauthenticated
    case authenticating
    case authenticated(User)
}
