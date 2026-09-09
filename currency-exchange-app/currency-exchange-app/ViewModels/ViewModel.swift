//
//  ViewModel.swift
//  currency-exchange-app
//
//  Created by jay on 9/9/26.
//

import Foundation
import Combine
import Observation

@Observable
final class ViewModel {
    var exchangeRate: ExchangeRate? = nil
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        fetchRates()
    }
    
    func fetchRates() {
        ExchangeRateService.shared.getExchangeRate()
            .replaceError(with: ExchangeRate.placeholder)
            .sink {[weak self] exchangeRate in
                self?.exchangeRate = exchangeRate
            }
            .store(in: &cancellableSet)
    }
    
    deinit {
        cancellableSet.forEach { it in
            it.cancel()
        }
    }
}

extension ViewModel {
    func validateOutput() -> [Dictionary<String, Double>.Keys.Element] {
        guard let output = exchangeRate?.rates?.keys.sorted() else {
            return []
        }
        return output
    }
    
    func emojiFlag(_ currencyCode: String) -> String {
        guard let country = Country.getCountryBy(currencyCode: currencyCode) else {
            return currencyCode
                .dropLast()
                .unicodeScalars
                .map { unicode in
                    127397 + unicode.value
                }
                .compactMap(UnicodeScalar.init)
                .map(String.init)
                .joined()
        }
        return country.flagEmoji
    }
    
    func countryName(currencyCode: String) -> String? {
        Country.getCountryBy(currencyCode: currencyCode)?.name
    }
    
    func formatRateForLocale(for key: String) -> String {
        guard let mainRates = exchangeRate?.rates else {
            return ""
        }
        
        let rate = mainRates.first { r in r.key == key }
        var formatter: NumberFormatter {
            let fm = NumberFormatter()
            fm.numberStyle = .currency
            fm.locale = Locale(identifier: key.dropLast() + "_" + key.dropLast().uppercased())
            return fm
        }
        
        return formatter.string(from: NSNumber(value: rate?.value ?? 1.0))!
    }
}
