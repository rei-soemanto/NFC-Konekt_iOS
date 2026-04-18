//
//  User.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//


import Foundation

struct User: Identifiable {
    let id: String
    var name: String?
    let email: String
}

enum AuthState {
    case unauthenticated
    case authenticating
    case authenticated(User)
}
