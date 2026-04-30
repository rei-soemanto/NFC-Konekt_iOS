//
//  LocalDataManager.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation
import Combine

class LocalDataManager {
    static let shared = LocalDataManager()
    
    private let defaults = UserDefaults.standard
    private let tokenKey = "auth_token"
    private let themeModeKey = "theme_mode"
    
    @Published private(set) var token: String?
    @Published private(set) var isDarkMode: Bool?
    
    private init() {
        self.token = defaults.string(forKey: tokenKey)
        if defaults.object(forKey: themeModeKey) != nil {
            self.isDarkMode = defaults.bool(forKey: themeModeKey)
        }
    }
    
    func saveToken(_ token: String) {
        defaults.set(token, forKey: tokenKey)
        self.token = token 
    }
    
    func clearToken() {
        defaults.removeObject(forKey: tokenKey)
        self.token = nil
    }
    
    func setThemeMode(isDark: Bool) {
        defaults.set(isDark, forKey: themeModeKey)
        self.isDarkMode = isDark
    }
}
