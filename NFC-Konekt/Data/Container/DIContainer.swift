import Foundation
import SwiftUI
import Combine

@MainActor
final class DIContainer: ObservableObject {
    
    let localDataManager: LocalDataManager
    let apiClient: APIClient
    
    let authApiService: AuthApiService
    let dashboardApiService: DashboardApiService
    let profileApiService: ProfileApiService
    let teamApiService: TeamApiService
    let contactApiService: ContactApiService
    let connectApiService: ConnectApiService
    let cardApiService: CardApiService
    let historyApiService: HistoryApiService
    let subscriptionApiService: SubscriptionApiService
    
    let authRepository: AuthRepository
    let dashboardRepository: DashboardRepository
    let profileRepository: ProfileRepository
    let teamRepository: TeamRepository
    let contactRepository: ContactRepository
    let connectRepository: ConnectRepository
    let cardRepository: CardRepository
    let historyRepository: HistoryRepository
    let subscriptionRepository: SubscriptionRepository
    
    init() {
        self.localDataManager = LocalDataManager.shared
        self.apiClient = APIClient(baseURL: "http://192.168.1.7:3000/api/")
        
        self.authApiService = DefaultAuthApiService(apiClient: apiClient)
        self.dashboardApiService = DefaultDashboardApiService(apiClient: apiClient)
        self.profileApiService = DefaultProfileApiService(apiClient: apiClient)
        self.teamApiService = DefaultTeamApiService(apiClient: apiClient)
        self.contactApiService = DefaultContactApiService(apiClient: apiClient)
        self.connectApiService = DefaultConnectApiService(apiClient: apiClient)
        self.cardApiService = DefaultCardApiService(apiClient: apiClient)
        self.historyApiService = DefaultHistoryApiService(apiClient: apiClient)
        self.subscriptionApiService = DefaultSubscriptionApiService(apiClient: apiClient)
        
        self.authRepository = AuthRepository(apiClient: apiClient, localData: localDataManager)
        self.dashboardRepository = DashboardRepository(apiClient: apiClient)
        self.profileRepository = ProfileRepository(apiClient: apiClient)
        self.teamRepository = TeamRepository(apiClient: apiClient)
        self.contactRepository = ContactRepository(apiClient: apiClient)
        self.connectRepository = ConnectRepository(apiClient: apiClient)
        self.cardRepository = CardRepository(apiClient: apiClient)
        self.historyRepository = HistoryRepository(apiClient: apiClient)
        self.subscriptionRepository = SubscriptionRepository(apiClient: apiClient)
    }
}
