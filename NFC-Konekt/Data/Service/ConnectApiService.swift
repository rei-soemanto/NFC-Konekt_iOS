//
//  ConnectApiService.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

protocol ConnectApiService {
    func getConnections(query: String?) async throws -> [DigitalConnectionDto]
    func addConnection(request: SlugRequest) async throws -> EmptyResponse
    func getScannedProfile(slug: String) async throws -> ProfileResponse
}

class DefaultConnectApiService: ConnectApiService {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getConnections(query: String?) async throws -> [DigitalConnectionDto] {
        let endpoint = query != nil ? "connect?q=\(query!)" : "connect"
        return try await apiClient.request(endpoint: endpoint, method: "GET")
    }
    
    func addConnection(request: SlugRequest) async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "connect", method: "POST", body: request)
    }
    
    func getScannedProfile(slug: String) async throws -> ProfileResponse {
        return try await apiClient.request(endpoint: "connect/\(slug)", method: "GET")
    }
}
