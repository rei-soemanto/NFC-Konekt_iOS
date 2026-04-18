//
//  AuthenticationView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static let twIndigo600 = Color(hex: "#4F46E5")
    static let twViolet600 = Color(hex: "#7C3AED")
    static let twGray100 = Color(hex: "#F3F4F6")
    static let twGray800 = Color(hex: "#1F2937")
    static let twGray900 = Color(hex: "#111827")
    static let twGray950 = Color(hex: "#030712")
}

struct AuthenticationView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color {
        colorScheme == .dark ? .twGray950 : .twGray100
    }
    
    var cardBackground: Color {
        colorScheme == .dark ? .twGray900 : .white
    }
    
    var textPrimary: Color {
        colorScheme == .dark ? .white : .twGray800
    }

    var body: some View {
        NavigationView {
            ZStack {
                appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "wifi")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(
                                        LinearGradient(colors: [.twIndigo600, .twViolet600], startPoint: .leading, endPoint: .trailing)
                                    )
                                Text("NFC Konekt")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(colors: [.twIndigo600, .twViolet600], startPoint: .leading, endPoint: .trailing)
                                    )
                            }
                            
                            Text(viewModel.isLoginMode ? "Sign In" : "Create Account")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(textPrimary)
                            
                            Text(viewModel.isLoginMode ? "Welcome back!" : "Sign up and discover new opportunities!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(colorScheme == .dark ? Color.red.opacity(0.2) : Color(hex: "#FEF2F2"))
                                .cornerRadius(8)
                                .padding(.horizontal)
                                .transition(.opacity)
                        }
                        
                        VStack(spacing: 16) {
                            if !viewModel.isLoginMode {
                                TextField("Full Name", text: $viewModel.name)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                            
                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
                                .cornerRadius(12)
                            
                            SecureField("Password", text: $viewModel.password)
                                .padding()
                                .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
                                .cornerRadius(12)
                            
                            if !viewModel.isLoginMode {
                                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                    .padding()
                                    .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            Task {
                                await viewModel.authenticate()
                            }
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(viewModel.isLoginMode ? "Sign In" : "Sign Up")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [.twIndigo600, .twViolet600], startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .disabled(viewModel.isLoading)
                        
                        Button(action: {
                            withAnimation(.snappy) {
                                viewModel.toggleMode()
                            }
                        }) {
                            Text(viewModel.isLoginMode ? "New Here? Sign Up" : "Already have an account? Sign In")
                                .font(.footnote)
                                .foregroundColor(.twIndigo600)
                        }
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .background(cardBackground)
                    .cornerRadius(24)
                    .shadow(color: colorScheme == .dark ? .twIndigo600.opacity(0.1) : .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview ("Light Mode") {
    AuthenticationView()
        .environmentObject(AuthViewModel())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    AuthenticationView()
        .environmentObject(AuthViewModel())
        .preferredColorScheme(.dark)
}
