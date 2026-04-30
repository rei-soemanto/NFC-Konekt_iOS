//
//  AuthRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class AuthRepository {
    private let apiClient: APIClient
    private let localData: LocalDataManager
    
    init(apiClient: APIClient, localData: LocalDataManager) {
        self.apiClient = apiClient
        self.localData = localData
    }
    
    func register(request: RegisterRequest) async throws -> AuthResponse {
        let response: AuthResponse = try await apiClient.request(endpoint: "auth/register", method: "POST", body: request)
        if let token = response.token { localData.saveToken(token) }
        return response
    }
    
    func login(request: LoginRequest) async throws -> AuthResponse {
        let response: AuthResponse = try await apiClient.request(endpoint: "auth/login", method: "POST", body: request)
        if let token = response.token { localData.saveToken(token) }
        return response
    }
    
    func logout() {
        localData.clearToken()
    }
    
    func changePassword(request: ChangePasswordRequest) async throws {
        let _: EmptyResponse = try await apiClient.request(endpoint: "auth/change-password", method: "PUT", body: request)
    }
    
    func deleteAccount(request: DeleteAccountRequest) async throws {
        let _: EmptyResponse = try await apiClient.request(endpoint: "auth/delete-account", method: "DELETE", body: request)
        logout()
    }
}

struct EmptyResponse: Decodable {}
