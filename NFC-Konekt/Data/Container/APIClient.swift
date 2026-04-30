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
    private let localData = LocalDataManager.shared
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: String,
        body: U? = nil
    ) async throws -> T {
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = localData.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("Server returned an error")
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingError
        }
    }
    
    func request<T: Decodable>(endpoint: String, method: String) async throws -> T {
        return try await request(endpoint: endpoint, method: method, body: EmptyBody?.none)
    }
}

struct EmptyBody: Encodable {}
