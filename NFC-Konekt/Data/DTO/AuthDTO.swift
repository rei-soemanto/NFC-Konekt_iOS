//
//  AuthDTO.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct RegisterRequest: Encodable {
    let fullName: String
    let email: String
    let password: String
}

struct ChangePasswordRequest: Encodable {
    let oldPassword: String
    let newPassword: String
}

struct DeleteAccountRequest: Encodable {
    let passwordConfirmation: String
}

struct AuthResponse: Decodable {
    let success: Bool
    let token: String?
    let user: AuthUser?
}

struct AuthUser: Decodable {
    let id: String
    let email: String
    let fullName: String
}
