//
//  AuthViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

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
    
    var isAuthenticated: Bool {
        if case .authenticated = authState { return true }
        return false
    }
    
    func toggleMode() {
        isLoginMode.toggle()
        errorMessage = nil
        name = ""
        password = ""
        confirmPassword = ""
    }
    
    func authenticate() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            
            if isLoginMode {
                guard !email.isEmpty, !password.isEmpty else {
                    errorMessage = "Please fill in all fields."
                    return
                }
                
                authState = .authenticated(User(id: UUID().uuidString, email: email))
                
            } else {
                guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
                    errorMessage = "Please fill in all fields."
                    return
                }
                guard password == confirmPassword else {
                    errorMessage = "Passwords do not match."
                    return
                }
                
                authState = .authenticated(User(id: UUID().uuidString, name: name, email: email))
            }
        } catch {
            errorMessage = "A network error occurred. Please try again."
        }
    }
    
    func logout() {
        authState = .unauthenticated
        name = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}
