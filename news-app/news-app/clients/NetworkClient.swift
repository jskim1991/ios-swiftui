//
//  NewsAPIClient.swift
//  news-app
//
//  Created by jay on 9/8/26.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingError
    case unknownError
}

struct NetworkClient {
    static let shared = NetworkClient()
    
    private init() {
        
    }
    
    func request<T: Decodable>(endpoint: String, method: HttpMethod = .get, parameters: [String: Any]? = nil, headers: [String: String]? = nil) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = parameters, method != .get {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
