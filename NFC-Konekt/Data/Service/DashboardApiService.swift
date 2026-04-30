//
//  DashboardApiService.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

protocol DashboardApiService {
    func getDashboard() async throws -> DashboardResponse
}

class DefaultDashboardApiService: DashboardApiService {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getDashboard() async throws -> DashboardResponse {
        return try await apiClient.request(endpoint: "dashboard", method: "GET")
    }
}
