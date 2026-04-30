//
//  SubscriptionApiService.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

protocol SubscriptionApiService {
    func getSubscriptionStatus() async throws -> SubscriptionStatusResponse
    func cancelSubscription() async throws -> EmptyResponse
    func markShipmentReceived() async throws -> EmptyResponse
    func initiateMobileCheckout(request: MobileCheckoutRequest) async throws -> MobileCheckoutResponse
}

class DefaultSubscriptionApiService: SubscriptionApiService {
    private let apiClient: APIClient
    init(apiClient: APIClient) { self.apiClient = apiClient }
    
    func getSubscriptionStatus() async throws -> SubscriptionStatusResponse {
        return try await apiClient.request(endpoint: "subscription/status", method: "GET")
    }
    
    func cancelSubscription() async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "subscription/cancel", method: "POST")
    }
    
    func markShipmentReceived() async throws -> EmptyResponse {
        return try await apiClient.request(endpoint: "subscription/shipment/receive", method: "POST")
    }
    
    func initiateMobileCheckout(request: MobileCheckoutRequest) async throws -> MobileCheckoutResponse {
        return try await apiClient.request(endpoint: "subscription/mobile-checkout", method: "POST", body: request)
    }
}
