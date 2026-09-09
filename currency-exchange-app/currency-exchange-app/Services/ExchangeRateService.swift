//
//  ExchangeRateService.swift
//  currency-exchange-app
//
//  Created by jay on 9/9/26.
//

import Foundation
import Combine

final class ExchangeRateService {
    static let shared = ExchangeRateService()
    
    func getExchangeRate() -> AnyPublisher<ExchangeRate, Error> {
        return session(ExchangeRate.self, with: Endpoint.default.url!)
    }
    
    func session<T: Codable>(_ type: T.Type, with url: URL) -> AnyPublisher<T, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: type.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .print()
            .eraseToAnyPublisher()
    }
}
