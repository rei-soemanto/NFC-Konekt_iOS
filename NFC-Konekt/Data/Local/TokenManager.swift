//
//  TokenManager.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 01/05/26.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let tokenKey = "auth_token"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    var isLoggedIn: Bool {
        return getToken() != nil
    }
}
