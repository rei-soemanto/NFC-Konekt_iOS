//
//  HistoryViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine

enum HistoryTab {
    case outbound
    case inbound
}

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var activeTab: HistoryTab = .outbound
    @Published var outboundList: [HistoryItemDto] = []
    @Published var inboundList: [HistoryItemDto] = []
    @Published var hasSubscription: Bool = false
    @Published var errorMessage: String? = nil
    
    private let historyRepository: HistoryRepository
    private let connectRepository: ConnectRepository
    private let subscriptionRepository: SubscriptionRepository
    
    init(historyRepository: HistoryRepository,
         connectRepository: ConnectRepository,
         subscriptionRepository: SubscriptionRepository) {
        self.historyRepository = historyRepository
        self.connectRepository = connectRepository
        self.subscriptionRepository = subscriptionRepository
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let historyTask = historyRepository.getHistory()
            async let subTask = subscriptionRepository.getSubscriptionStatus()
            
            let historyResponse = try await historyTask
            let subResponse = try await subTask
            
            let isActiveSub = subResponse.status == "ACTIVE"
            
            self.outboundList = historyResponse.data?.scannedByMe ?? []
            self.inboundList = historyResponse.data?.scannedByOthers ?? []
            self.hasSubscription = isActiveSub
            
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            print("❌ Failed to load history data: \(error)")
        }
    }
    
    func setTab(_ tab: HistoryTab) {
        self.activeTab = tab
    }
    
    func connect(personId: String, slug: String?) async {
        do {
            if let targetSlug = slug {
                try await connectRepository.addConnection(slug: targetSlug)
            }
            
            if let index = outboundList.firstIndex(where: { $0.person.id == personId }) {
                outboundList[index].isConnected = true
            }
            
            if let index = inboundList.firstIndex(where: { $0.person.id == personId }) {
                inboundList[index].isConnected = true
            }
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Failed to connect: \(error)")
        }
    }
}
