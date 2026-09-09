//
//  Course.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import Foundation

struct Course: Identifiable, Hashable {
    let id = UUID().uuidString
    var title: String
    var category: Category
    var duration: String
    var publishedDate: Date
    var desc: String
    var price: Double
}

extension Course {
    static var sampleData: [Course] = {
        let raw: [(String, Category, String, String, Double)] = [
            ("Learn iOS", .swiftUI, "30h", "Learn iOS development from scratch", 99.99),
            ("SwiftUI Animations Deep Dive", .swiftUI, "8h 45m", "Master fluid animations and transitions in SwiftUI", 49.99),
            ("Spring Boot Zero to Hero", .server, "42h", "Become a backend pro with Spring Boot", 129.99),
            ("Practical Machine Learning", .machineLearning, "5h 10m", "Machine learning course for your daily job", 39.99),
            ("Core Data Essentials", .swiftUI, "6h 20m", "Persist and query data the right way on Apple platforms", 44.99),
            ("Building REST APIs with Vapor", .server, "12h 30m", "Server-side Swift for scalable APIs", 59.99),
            ("Deep Learning with PyTorch", .machineLearning, "18h", "Neural networks from tensors to training loops", 89.99),
            ("Concurrency in Swift", .swiftUI, "7h 15m", "async/await, actors, and structured concurrency", 54.99),
            ("Kubernetes for Developers", .server, "15h 40m", "Deploy and scale containerized services", 79.99),
            ("Natural Language Processing", .machineLearning, "9h 55m", "Text classification, embeddings, and transformers", 64.99),
            ("SwiftData Fundamentals", .swiftUI, "4h 30m", "The modern replacement for Core Data", 34.99),
            ("GraphQL API Design", .server, "10h", "Design flexible schemas and resolvers", 49.99),
            ("Computer Vision Basics", .machineLearning, "11h 20m", "Image recognition and detection pipelines", 69.99),
            ("Accessibility in SwiftUI", .swiftUI, "3h 45m", "Build apps everyone can use", 29.99),
            ("Microservices with Go", .server, "20h", "Design resilient distributed systems", 94.99),
            ("Reinforcement Learning", .machineLearning, "22h 30m", "Agents, rewards, and policy optimization", 109.99),
            ("Advanced SwiftUI Layout", .swiftUI, "6h", "Custom layouts, GeometryReader, and containers", 44.99),
            ("Database Performance Tuning", .server, "9h 10m", "Indexes, query plans, and caching strategies", 59.99),
            ("MLOps in Production", .machineLearning, "14h", "Ship, monitor, and retrain models at scale", 84.99),
            ("Testing SwiftUI Apps", .swiftUI, "5h 25m", "Unit and UI testing with the Testing framework", 39.99),
            ("Event-Driven Architecture", .server, "13h 50m", "Kafka, queues, and eventual consistency", 74.99),
            ("Generative AI Foundations", .machineLearning, "16h 40m", "LLMs, diffusion models, and prompting", 99.99),
            ("Combine to Async Migration", .swiftUI, "4h", "Move from Combine pipelines to async sequences", 29.99),
            ("Authentication & Security", .server, "8h 30m", "OAuth, JWT, and secure session handling", 54.99),
            ("Time Series Forecasting", .machineLearning, "10h 15m", "Predict trends with statistical and ML models", 64.99),
            ("Widgets and Live Activities", .swiftUI, "5h 50m", "Extend your app to the Home and Lock Screen", 39.99),
            ("Caching with Redis", .server, "6h 45m", "Speed up services with in-memory data stores", 44.99),
            ("Recommender Systems", .machineLearning, "12h", "Collaborative filtering and ranking models", 69.99),
            ("App Store Deployment", .swiftUI, "2h 40m", "From archive to release with confidence", 24.99),
            ("Observability & Logging", .server, "7h 30m", "Metrics, tracing, and structured logs", 49.99)
        ]

        let now = Date()
        let day: TimeInterval = 86_400
        return raw.enumerated().map { index, item in
            Course(
                title: item.0,
                category: item.1,
                duration: item.2,
                publishedDate: now.addingTimeInterval(-Double(index) * 9 * day),
                desc: item.3,
                price: item.4
            )
        }
    }()
}
