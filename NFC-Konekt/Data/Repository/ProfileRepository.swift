//
//  ProfileRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class ProfileRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getProfile() async throws -> ProfileResponse {
        let baseResponse: ProfileBaseResponse = try await apiClient.request(endpoint: "profile", method: "GET")
        return baseResponse.data
    }
    
    func updatePersonalProfile(request: UpdatePersonalRequest) async throws {
        let _: EmptyResponse = try await apiClient.request(endpoint: "profile/personal", method: "PUT", body: request)
    }
    
    func updateAddress(request: UpdateAddressRequest) async throws {
        let _: EmptyResponse = try await apiClient.request(endpoint: "profile/address", method: "PUT", body: request)
    }
    
    func updateCorporateProfile(request: UpdateCorporateRequest) async throws {
        let _: EmptyResponse = try await apiClient.request(endpoint: "profile/corporate", method: "PUT", body: request)
    }
    
    func getCountries() async throws -> [LocationItemDTO] {
        return try await apiClient.request(endpoint: "locations/countries", method: "GET")
    }
    
    func getStates(countryCode: String) async throws -> [LocationItemDTO] {
        return try await apiClient.request(endpoint: "locations/states?country=\(countryCode)", method: "GET")
    }
    
    func getCities(countryCode: String, stateCode: String) async throws -> [LocationItemDTO] {
        return try await apiClient.request(endpoint: "locations/cities?country=\(countryCode)&state=\(stateCode)", method: "GET")
    }
}
