//
//  AppConfig.swift
//  news-app
//

import Foundation

enum AppConfig {
    static let newsAPIKey: String = value(for: "NEWS_API_KEY")

    private static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty else {
            fatalError("Missing \(key) — copy Config/Secrets.example.xcconfig to Config/Secrets.xcconfig")
        }
        return value
    }
}
