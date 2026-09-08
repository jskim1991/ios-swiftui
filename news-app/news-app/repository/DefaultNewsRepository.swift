//
//  DefaultNewsRepository.swift
//  news-app
//
//  Created by jay on 9/8/26.
//

import Foundation

struct DefaultNewsRepository: NewsRepository {

    private let manager: NetworkClient
    private let apiKey: String
    private let baseURL = "https://newsapi.org/v2/top-headlines"

    init(manager: NetworkClient, apiKey: String) {
        self.manager = manager
        self.apiKey = apiKey
    }

    func topHeadlines() async throws -> News {
        do {
            let news: News = try await manager.request(endpoint: "\(baseURL)?country=us&category=business&apiKey=\(apiKey)")
            return news
        } catch {
            throw error
        }
    }
}
