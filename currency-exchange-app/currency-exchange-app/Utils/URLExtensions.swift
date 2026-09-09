//
//  URLExtensions.swift
//  currency-exchange-app
//
//  Created by jay on 9/9/26.
//

import Foundation

extension URL {
    func setQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map({ (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        })
        return components?.url
    }
}
