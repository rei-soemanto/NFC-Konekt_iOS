//
//  APIClient.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case serverError(String)
    case decodingError
}

class APIClient {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: String,
        body: U
    ) async throws -> T {
        let encodedBody = try? JSONEncoder().encode(body)
        return try await performRequest(endpoint: endpoint, method: method, encodedBody: encodedBody)
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: String
    ) async throws -> T {
        return try await performRequest(endpoint: endpoint, method: method, encodedBody: nil)
    }
    
    private func performRequest<T: Decodable>(
        endpoint: String,
        method: String,
        encodedBody: Data?
    ) async throws -> T {
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = TokenManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = encodedBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let errorString = String(data: data, encoding: .utf8) {
                print("❌ API Error [\(endpoint)]: \(errorString)")
            }
            throw APIError.serverError("Server returned status code \((response as? HTTPURLResponse)?.statusCode ?? 500)")
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("📦 RAW JSON from \(endpoint):")
            print(String(data: data, encoding: .utf8) ?? "Unable to print raw data")
            print("❌ DECODING ERROR: \(error)")
            throw APIError.decodingError
        }
    }
}
