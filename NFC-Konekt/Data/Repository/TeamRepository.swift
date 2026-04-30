//
//  TeamRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class TeamRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getTeamData() async throws -> TeamStatsResponse {
        let response: TeamDataResponse = try await apiClient.request(endpoint: "team", method: "GET")
        let payload = response.data
        
        return TeamStatsResponse(
            currentUsage: payload.stats.totalMembers,
            maxUsage: 10,
            planName: "Corporate Plan",
            members: payload.members
        )
    }
    
    func addMember(request: AddTeamMemberRequest) async throws -> TeamMemberDto {
        let response: SingleMemberResponse = try await apiClient.request(
            endpoint: "team/members",
            method: "POST",
            body: request
        )
        return response.data
    }
    
    func updateMember(id: String, request: UpdateMemberRequest) async throws -> TeamMemberDto {
        let backendRequest = UpdateTeamMemberRequest(
            role: nil,
            isHidden: !request.isCompanyPublic, 
            jobTitle: request.jobTitle
        )
        
        let response: SingleMemberResponse = try await apiClient.request(
            endpoint: "team/members/\(id)",
            method: "PUT",
            body: backendRequest
        )
        return response.data
    }
    
    func removeMember(id: String) async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "team/members/\(id)",
            method: "DELETE"
        )
    }
    
    func getTeamCards() async throws -> TeamCardsResponse {
        return try await apiClient.request(endpoint: "team/cards", method: "GET")
    }
}
