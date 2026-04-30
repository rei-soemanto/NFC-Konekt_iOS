//
//  DashboardViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine

enum DashboardUiState {
    case loading
    case success(DashboardResponse)
    case error(String)
}

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var uiState: DashboardUiState = .loading
    @Published var isRefreshing = false
    
    private let repository: DashboardRepository
    
    init(repository: DashboardRepository) {
        self.repository = repository
    }
    
    func loadData() async {
        uiState = .loading
        do {
            let response = try await repository.getDashboardData()
            uiState = .success(response)
        } catch {
            uiState = .error(error.localizedDescription)
            print("❌ Failed to load dashboard: \(error)")
        }
    }
    
    func refreshData() async {
        isRefreshing = true
        do {
            let response = try await repository.getDashboardData()
            uiState = .success(response)
        } catch {
            print("❌ Failed to refresh dashboard: \(error)")
        }
        isRefreshing = false
    }
}
