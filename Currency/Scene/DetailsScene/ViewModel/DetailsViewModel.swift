//
//  DetailsViewModel.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation

class DetailsViewModel: BaseViewModel {
    
    var repository: DetailsRepository
    private let fromCurrency: String
    private let toCurrency: String
    private let otherCurrencies: [String: Double]
    init(repository: DetailsRepository, fromCurrency: String,toCurrency: String, otherCurrencies: [String: Double]) {
        self.repository = repository
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.otherCurrencies = otherCurrencies
    }
}
