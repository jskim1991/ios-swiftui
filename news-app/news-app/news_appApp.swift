//
//  news_appApp.swift
//  news-app
//
//  Created by jay on 9/8/26.
//

import SwiftUI

@main
struct news_appApp: App {
    private let repository = DefaultNewsRepository(
        manager: NetworkClient.shared,
        apiKey: AppConfig.newsAPIKey
    )

    var body: some Scene {
        WindowGroup {
            ContentView(repository: repository)
        }
    }
}
