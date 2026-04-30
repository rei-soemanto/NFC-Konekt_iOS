//
//  ContactApiService.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

protocol ContactApiService {
    func getContacts() async throws -> [PhysicalContactDto]
    func addContact(request: AddContactRequest) async throws -> EmptyResponse
    func updateContact(id: String, request: AddContactRequest) async throws -> EmptyResponse
    func deleteContact(id: String) async throws -> EmptyResponse
}

class DefaultContactApiService: ContactApiService {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getContacts() async throws -> [PhysicalContactDto] {
        return try await apiClient.request(endpoint: "contacts", method: "GET")
    }
    
    func addContact(request: AddContactRequest) async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "contacts", method: "POST", body: request)
    }
    
    func updateContact(id: String, request: AddContactRequest) async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "contacts/\(id)", method: "PATCH", body: request)
    }
    
    func deleteContact(id: String) async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "contacts/\(id)", method: "DELETE")
    }
}
