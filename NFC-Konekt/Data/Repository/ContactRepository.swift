//
//  ContactRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class ContactRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getContacts() async throws -> [PhysicalContactDto] {
        let response: ContactBaseResponse = try await apiClient.request(endpoint: "contacts", method: "GET")
        return response.data
    }
    
    func addContact(request: AddContactRequest) async throws -> PhysicalContactDto {
        return try await apiClient.request(
            endpoint: "contacts",
            method: "POST",
            body: request
        )
    }
    
    func updateContact(id: String, request: AddContactRequest) async throws -> PhysicalContactDto {
        return try await apiClient.request(
            endpoint: "contacts/\(id)",
            method: "PUT",
            body: request
        )
    }
    
    func deleteContact(id: String) async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "contacts/\(id)",
            method: "DELETE"
        )
    }
}
