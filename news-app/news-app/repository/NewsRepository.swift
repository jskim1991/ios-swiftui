//
//  NewsRepository.swift
//  news-app
//
//  Created by jay on 9/8/26.
//

protocol NewsRepository {
    func topHeadlines() async throws -> News
}
