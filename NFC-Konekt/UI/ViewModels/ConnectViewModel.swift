//
//  ConnectViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Combine
import Foundation
import SwiftUI

enum ConnectionStatus {
    case notConnected, connected, selfUser
}

@MainActor
class ConnectViewModel: ObservableObject {
    @Published var isLoadingList: Bool = true
    @Published var isLocked: Bool = false
    @Published var connections: [DigitalConnectionDto] = []
    @Published var searchQuery: String = ""
    @Published var selectedIndustry: String = "All"
    
    @Published var isScanningActive: Bool = false
    @Published var isFetchingProfile: Bool = false
    @Published var scannedUser: ProfileResponse? = nil
    @Published var connectionStatus: ConnectionStatus = .notConnected
    @Published var scanErrorMessage: String? = nil
    
    private let connectRepository: ConnectRepository
    private let subscriptionRepository: SubscriptionRepository
    
    init(connectRepository: ConnectRepository, subscriptionRepository: SubscriptionRepository) {
        self.connectRepository = connectRepository
        self.subscriptionRepository = subscriptionRepository
    }
    
    func loadConnections() async {
        isLoadingList = true
        do {
            let subStatus = try await subscriptionRepository.getSubscriptionStatus()
            if subStatus.status != "ACTIVE" {
                isLocked = true
                isLoadingList = false
                return
            }
            
            self.connections = try await connectRepository.getConnections(query: nil)
            self.isLocked = false
        } catch {
            self.isLocked = true
            print("❌ Failed to load connections: \(error)")
        }
        isLoadingList = false
    }
    
    var availableIndustries: [String] {
        var industries = Set(connections.compactMap { $0.companyScope })
        var sorted = Array(industries).sorted()
        sorted.insert("All", at: 0)
        return sorted
    }
    
    var filteredConnections: [DigitalConnectionDto] {
        connections.filter { conn in
            let matchesSearch = searchQuery.isEmpty ||
                conn.fullName.localizedCaseInsensitiveContains(searchQuery) ||
                conn.email.localizedCaseInsensitiveContains(searchQuery) ||
                (conn.jobTitle?.localizedCaseInsensitiveContains(searchQuery) ?? false) ||
                (conn.companyName?.localizedCaseInsensitiveContains(searchQuery) ?? false)
            
            let matchesIndustry = selectedIndustry == "All" || conn.companyScope == selectedIndustry
            return matchesSearch && matchesIndustry
        }
    }
    
    func startScanning() { isScanningActive = true }
    func cancelScanning() {
        isScanningActive = false
        scannedUser = nil
        scanErrorMessage = nil
    }
    func resetScan() {
        scannedUser = nil
        scanErrorMessage = nil
        connectionStatus = .notConnected
    }
    
    func fetchScannedProfile(slug: String) async {
        isFetchingProfile = true
        scanErrorMessage = nil
        isScanningActive = true
        
        do {
            let response = try await connectRepository.getScannedProfile(slug: slug)
            self.scannedUser = response
            self.connectionStatus = .notConnected 
        } catch {
            self.scanErrorMessage = error.localizedDescription
        }
        isFetchingProfile = false
    }
    
    func saveContact(userId: String) async {
        do {
            let _ = try await connectRepository.addConnection(slug: userId)
            self.connectionStatus = .connected
            await loadConnections()
        } catch {
            self.scanErrorMessage = error.localizedDescription
        }
    }
}
