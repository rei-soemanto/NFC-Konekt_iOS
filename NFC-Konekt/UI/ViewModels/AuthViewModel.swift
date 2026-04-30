import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoginMode = true
    
    @Published var authState: AuthState = .unauthenticated
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var securityConfirmPassword = ""
    @Published var deletePasswordInput = ""
    @Published var showDeleteConfirmation = false
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    var isAuthenticated: Bool {
        if case .authenticated = authState { return true }
        return false
    }
    
    func toggleMode() {
        isLoginMode.toggle()
        errorMessage = nil
        name = ""; password = ""; confirmPassword = ""
    }
    
    func authenticate() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            if isLoginMode {
                let request = LoginRequest(email: email, password: password)
                let response = try await repository.login(request: request)
                if let userDto = response.user {
                    authState = .authenticated(User(authDto: userDto))
                }
            } else {
                guard password == confirmPassword else {
                    errorMessage = "Passwords do not match."
                    return
                }
                let request = RegisterRequest(fullName: name, email: email, password: password)
                let response = try await repository.register(request: request)
                if let userDto = response.user {
                    authState = .authenticated(User(authDto: userDto))
                }
            }
        } catch {
            errorMessage = "Authentication failed: \(error.localizedDescription)"
        }
    }
    
    func logout() {
        repository.logout()
        authState = .unauthenticated
        name = ""; email = ""; password = ""; confirmPassword = ""
    }
    
    func changePassword() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let request = ChangePasswordRequest(oldPassword: currentPassword, newPassword: newPassword)
            try await repository.changePassword(request: request)
            currentPassword = ""; newPassword = ""; securityConfirmPassword = ""
        } catch { errorMessage = error.localizedDescription }
    }
    
    func deleteAccount() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let request = DeleteAccountRequest(passwordConfirmation: deletePasswordInput)
            try await repository.deleteAccount(request: request)
            logout()
        } catch { errorMessage = error.localizedDescription }
    }
}
