//
//  ConnectViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class ConnectViewModel: ObservableObject {
    @Published var isLocked: Bool = false
    @Published var connections: [DigitalConnection] = []
    @Published var searchQuery: String = ""
    @Published var selectedIndustry: String = "All"
    
    init() {
        connections = [
            DigitalConnection(id: "c1", fullName: "Antonius Pramudiya", email: "antonius@wraksa.com", avatarUrl: nil, jobTitle: "CEO", companyName: "PT. Wraksa Kencana Mukti", companyScope: "Technology", companySpeciality: "Software", companyLogoUrl: nil),
            DigitalConnection(id: "c2", fullName: "Sarah Jenkins", email: "sarah@designco.com", avatarUrl: nil, jobTitle: "Lead Designer", companyName: "DesignCo", companyScope: "Creative", companySpeciality: "UI/UX", companyLogoUrl: nil)
        ]
    }
    
    var availableIndustries: [String] {
        var industries = Set(connections.compactMap { $0.companyScope })
        var sorted = Array(industries).sorted()
        sorted.insert("All", at: 0)
        return sorted
    }
    
    var filteredConnections: [DigitalConnection] {
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
}
