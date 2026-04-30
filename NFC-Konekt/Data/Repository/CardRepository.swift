//
//  CardRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class CardRepository {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getCardWritePayload(request: SlugRequest) async throws -> [String: String] {
        return try await apiClient.request(
            endpoint: "card/write-payload",
            method: "POST",
            body: request
        )
    }
}
