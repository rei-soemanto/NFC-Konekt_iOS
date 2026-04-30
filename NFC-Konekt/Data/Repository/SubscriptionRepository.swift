//
//  SubscriptionRepository.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

class SubscriptionRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getSubscriptionStatus() async throws -> SubscriptionStatusData {
        let response: SubscriptionStatusResponse = try await apiClient.request(
            endpoint: "subscription/status", 
            method: "GET"
        )
        return response.data
    }
    
    func cancelSubscription() async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "subscription/cancel",
            method: "POST" 
        )
    }
    
    func markShipmentReceived() async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "subscription/shipment-received",
            method: "POST"
        )
    }
    
    func initiateMobileCheckout(request: MobileCheckoutRequest) async throws -> MobileCheckoutResponse {
        return try await apiClient.request(
            endpoint: "subscription/checkout",
            method: "POST",
            body: request
        )
    }
}
