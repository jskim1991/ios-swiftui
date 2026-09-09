//
//  DoubleExt.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import Foundation

extension Double {
    func formattedCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        return formatter.string(from: NSNumber(value: self)) ?? "$0"
    }
}
