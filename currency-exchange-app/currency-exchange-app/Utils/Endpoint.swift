//
//  Endpoint.swift
//  currency-exchange-app
//
//  Created by jay on 9/9/26.
//

import Foundation

private let API_KEY: String = {
    guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
          let secrets = NSDictionary(contentsOf: url) as? [String: Any],
          let key = secrets["API_KEY"] as? String else {
        fatalError("Missing API_KEY in Secrets.plist")
    }
    return key
}()

enum Endpoint {
    case `default`
    case withSymbols
    
    private var baseURL: URL {
        URL(string: "https://api.exchangeratesapi.io/v1/latest")!
    }
    
    var url: URL? {
        baseURL.setQueries(query())
    }
    
    func query() -> [String: String] {
        switch self {
        case .default:
            return ["access_key": API_KEY]
        case .withSymbols:
            return [
                "access_key": API_KEY,
                "symbols": "KRW,JPY,EUR"
            ]
        }
    }
}
