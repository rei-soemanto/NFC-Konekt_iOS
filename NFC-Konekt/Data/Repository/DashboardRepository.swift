//
//  DashboardRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class DashboardRepository {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getDashboardData() async throws -> DashboardResponse {
        return try await apiClient.request(endpoint: "dashboard", method: "GET")
    }
}
