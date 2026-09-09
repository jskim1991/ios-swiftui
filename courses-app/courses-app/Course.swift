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
}

extension Course {
    static var sampleData: [Course] = {
        let raw: [(String, Category, String, String)] = [
            ("Learn iOS", .swiftUI, "30h", "Learn iOS development from scratch"),
            ("SwiftUI Animations Deep Dive", .swiftUI, "8h 45m", "Master fluid animations and transitions in SwiftUI"),
            ("Spring Boot Zero to Hero", .server, "42h", "Become a backend pro with Spring Boot"),
            ("Practical Machine Learning", .machineLearning, "5h 10m", "Machine learning course for your daily job"),
            ("Core Data Essentials", .swiftUI, "6h 20m", "Persist and query data the right way on Apple platforms"),
            ("Building REST APIs with Vapor", .server, "12h 30m", "Server-side Swift for scalable APIs"),
            ("Deep Learning with PyTorch", .machineLearning, "18h", "Neural networks from tensors to training loops"),
            ("Concurrency in Swift", .swiftUI, "7h 15m", "async/await, actors, and structured concurrency"),
            ("Kubernetes for Developers", .server, "15h 40m", "Deploy and scale containerized services"),
            ("Natural Language Processing", .machineLearning, "9h 55m", "Text classification, embeddings, and transformers"),
            ("SwiftData Fundamentals", .swiftUI, "4h 30m", "The modern replacement for Core Data"),
            ("GraphQL API Design", .server, "10h", "Design flexible schemas and resolvers"),
            ("Computer Vision Basics", .machineLearning, "11h 20m", "Image recognition and detection pipelines"),
            ("Accessibility in SwiftUI", .swiftUI, "3h 45m", "Build apps everyone can use"),
            ("Microservices with Go", .server, "20h", "Design resilient distributed systems"),
            ("Reinforcement Learning", .machineLearning, "22h 30m", "Agents, rewards, and policy optimization"),
            ("Advanced SwiftUI Layout", .swiftUI, "6h", "Custom layouts, GeometryReader, and containers"),
            ("Database Performance Tuning", .server, "9h 10m", "Indexes, query plans, and caching strategies"),
            ("MLOps in Production", .machineLearning, "14h", "Ship, monitor, and retrain models at scale"),
            ("Testing SwiftUI Apps", .swiftUI, "5h 25m", "Unit and UI testing with the Testing framework"),
            ("Event-Driven Architecture", .server, "13h 50m", "Kafka, queues, and eventual consistency"),
            ("Generative AI Foundations", .machineLearning, "16h 40m", "LLMs, diffusion models, and prompting"),
            ("Combine to Async Migration", .swiftUI, "4h", "Move from Combine pipelines to async sequences"),
            ("Authentication & Security", .server, "8h 30m", "OAuth, JWT, and secure session handling"),
            ("Time Series Forecasting", .machineLearning, "10h 15m", "Predict trends with statistical and ML models"),
            ("Widgets and Live Activities", .swiftUI, "5h 50m", "Extend your app to the Home and Lock Screen"),
            ("Caching with Redis", .server, "6h 45m", "Speed up services with in-memory data stores"),
            ("Recommender Systems", .machineLearning, "12h", "Collaborative filtering and ranking models"),
            ("App Store Deployment", .swiftUI, "2h 40m", "From archive to release with confidence"),
            ("Observability & Logging", .server, "7h 30m", "Metrics, tracing, and structured logs")
        ]

        let now = Date()
        let day: TimeInterval = 86_400
        return raw.enumerated().map { index, item in
            Course(
                title: item.0,
                category: item.1,
                duration: item.2,
                publishedDate: now.addingTimeInterval(-Double(index) * 9 * day),
                desc: item.3
            )
        }
    }()
}
