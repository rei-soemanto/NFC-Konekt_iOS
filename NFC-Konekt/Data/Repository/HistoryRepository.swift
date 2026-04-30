//
//  HistoryRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class HistoryRepository {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getHistory() async throws -> HistoryResponse {
        return try await apiClient.request(endpoint: "history", method: "GET")
    }
}
