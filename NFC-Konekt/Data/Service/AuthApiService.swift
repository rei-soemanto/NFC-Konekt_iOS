//
//  AuthApiService.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

protocol AuthApiService {
    func login(request: LoginRequest) async throws -> AuthResponse
    func register(request: RegisterRequest) async throws -> AuthResponse
    func changePassword(request: ChangePasswordRequest) async throws -> EmptyResponse
    func deleteAccount() async throws -> EmptyResponse
}

class DefaultAuthApiService: AuthApiService {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func login(request: LoginRequest) async throws -> AuthResponse {
        return try await apiClient.request(endpoint: "auth/login", method: "POST", body: request)
    }
    
    func register(request: RegisterRequest) async throws -> AuthResponse {
        return try await apiClient.request(endpoint: "auth/register", method: "POST", body: request)
    }
    
    func changePassword(request: ChangePasswordRequest) async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "auth/change-password", method: "POST", body: request)
    }
    
    func deleteAccount() async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "auth/delete-account", method: "DELETE")
    }
}
