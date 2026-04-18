//
//  HistoryViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var activeTab: HistoryTab = .outbound
    @Published var outboundList: [HistoryItem] = []
    @Published var inboundList: [HistoryItem] = []
    @Published var hasSubscription: Bool = true
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        let person1 = Person(id: "u1", fullName: "Antonius Pramudiya", email: "antonius@wraksa.com", jobTitle: "CEO", companyName: "PT. Wraksa Kencana Mukti", avatarUrl: nil)
        let person2 = Person(id: "u2", fullName: "Michelle", email: "michelle@example.com", jobTitle: "Designer", companyName: "Creative Studio", avatarUrl: nil)
        let person3 = Person(id: "u3", fullName: "Budi Santoso", email: "budi.s@techindo.id", jobTitle: "Lead Engineer", companyName: "Tech Indo", avatarUrl: nil)
        
        outboundList = [
            HistoryItem(id: "h1", scannedAt: Date().addingTimeInterval(-3600), person: person1, isConnected: true),
            HistoryItem(id: "h2", scannedAt: Date().addingTimeInterval(-86400 * 2), person: person3, isConnected: false)
        ]
        
        inboundList = [
            HistoryItem(id: "h3", scannedAt: Date().addingTimeInterval(-7200), person: person2, isConnected: true)
        ]
    }
    
    func connect(with personId: String) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if let index = outboundList.firstIndex(where: { $0.person.id == personId }) {
            outboundList[index].isConnected = true
        }
        if let index = inboundList.firstIndex(where: { $0.person.id == personId }) {
            inboundList[index].isConnected = true
        }
    }
}
