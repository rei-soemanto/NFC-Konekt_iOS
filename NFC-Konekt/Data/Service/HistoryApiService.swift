//
//  HistoryApiService.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

protocol HistoryApiService {
    func getHistory() async throws -> HistoryResponse
}

class DefaultHistoryApiService: HistoryApiService {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getHistory() async throws -> HistoryResponse {
        return try await apiClient.request(endpoint: "history", method: "GET")
    }
}
