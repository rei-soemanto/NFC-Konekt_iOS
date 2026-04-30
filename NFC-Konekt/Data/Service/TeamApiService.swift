//
//  TeamApiService.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

protocol TeamApiService {
    func getTeamData() async throws -> TeamDataResponse
    func addTeamMember(request: AddTeamMemberRequest) async throws -> SingleMemberResponse
    func updateTeamMember(id: String, request: UpdateTeamMemberRequest) async throws -> SingleMemberResponse
    func removeTeamMember(id: String) async throws -> EmptyResponse
    func getTeamCards() async throws -> TeamCardsResponse
}

class DefaultTeamApiService: TeamApiService {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getTeamData() async throws -> TeamDataResponse {
        return try await apiClient.request(endpoint: "team", method: "GET")
    }
    
    func addTeamMember(request: AddTeamMemberRequest) async throws -> SingleMemberResponse {
        return try await apiClient.request(endpoint: "team", method: "POST", body: request)
    }
    
    func updateTeamMember(id: String, request: UpdateTeamMemberRequest) async throws -> SingleMemberResponse {
        return try await apiClient.request(endpoint: "team/\(id)", method: "PATCH", body: request)
    }
    
    func removeTeamMember(id: String) async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "team/\(id)", method: "DELETE")
    }
    
    func getTeamCards() async throws -> TeamCardsResponse {
        return try await apiClient.request(endpoint: "team/cards", method: "GET")
    }
}
