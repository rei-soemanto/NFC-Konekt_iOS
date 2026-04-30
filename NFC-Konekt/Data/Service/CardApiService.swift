//
//  CardApiService.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

protocol CardApiService {
    func getCardWritePayload(request: SlugRequest) async throws -> [String: String]
}

class DefaultCardApiService: CardApiService {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getCardWritePayload(request: SlugRequest) async throws -> [String: String] {
        return try await apiClient.request(endpoint: "cards/writer", method: "POST", body: request)
    }
}
