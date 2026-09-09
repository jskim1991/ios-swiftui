//
//  ExchangeRate.swift
//  currency-exchange-app
//
//  Created by jay on 9/9/26.
//

import Foundation

struct ExchangeRate: Codable, Identifiable, Equatable {
    let id = UUID()
    let date: String?
    let rates: [String: Double]?
    
    private enum CodingKeys: String, CodingKey {
        case date, rates
    }
}

extension ExchangeRate {
    static var placeholder: ExchangeRate {
        Self (date: nil, rates: nil)
    }
}
