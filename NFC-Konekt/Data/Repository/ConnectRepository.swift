//
//  ConnectRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class ConnectRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getConnections(query: String? = nil) async throws -> [DigitalConnectionDto] {
        var endpoint = "connect"
        if let query = query, !query.isEmpty {
            endpoint += "?query=\(query)"
        }
        return try await apiClient.request(endpoint: endpoint, method: "GET")
    }
    
    func addConnection(slug: String) async throws -> EmptyResponse {
        return try await apiClient.request(
            endpoint: "connect/add",
            method: "POST",
            body: SlugRequest(slug: slug)
        )
    }
    
    func getScannedProfile(slug: String) async throws -> ProfileResponse {
        return try await apiClient.request(endpoint: "connect/profile/\(slug)", method: "GET")
    }
}
