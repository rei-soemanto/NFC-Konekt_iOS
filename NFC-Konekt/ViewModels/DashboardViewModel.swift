//
//  DashboardViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine

// MARK: - ViewModel
@MainActor
class DashboardViewModel: ObservableObject {
    @Published var userName: String = "Rei Soemanto"
    @Published var role: String = "Full-Stack Developer"
    @Published var company: String = "PT. Wraksa Kencana Mukti"
    
    @Published var activeCards: [DigitalIDCard] = []
    @Published var isRefreshing = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Mock data to populate the UI
        activeCards = [
            DigitalIDCard(title: "Employee Badge", subtitle: "HQ & Server Room Access", cardNumber: "ID-8472-991", isPrimary: true),
            DigitalIDCard(title: "Digital Business Card", subtitle: "Public Contact Info", cardNumber: "BC-1029-442", isPrimary: false)
        ]
    }
    
    func refreshData() async {
        isRefreshing = true
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        isRefreshing = false
    }
}
