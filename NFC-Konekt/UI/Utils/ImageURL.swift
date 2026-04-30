//
//  ImageURL.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

extension String {
    func toFullImageURL() -> URL? {
        guard !self.isEmpty else { return nil }
        
        if self.hasPrefix("http://") || self.hasPrefix("https://") {
            return URL(string: self)
        }
        
        let baseURL = "http://192.168.1.7:3000"
        
        let formattedPath = self.hasPrefix("/") ? self : "/\(self)"
        
        return URL(string: "\(baseURL)\(formattedPath)")
    }
}

// MARK: - Optional Support
// This is the magic trick. It allows you to call this function directly on an Optional String!
extension Optional where Wrapped == String {
    func toFullImageURL() -> URL? {
        guard let self = self, !self.isEmpty else { return nil }
        return self.toFullImageURL()
    }
}
