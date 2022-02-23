//
//  DetailsViewModel.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation
import RxSwift
import RxCocoa


class DetailsViewModel: BaseViewModel {
    
    var repository: DetailsRepository
    let fromCurrency: String
    let fromCurrencyRate: Double
    let toCurrency: String
    let currencies: [String:Double]
    var otherCurrencies = PublishSubject<[String: Double]>()
    var lastDays = PublishSubject<[String: Double]>()

    init(repository: DetailsRepository, fromCurrency: String, fromCurrencyRate: Double, toCurrency: String, otherCurrencies: [String: Double]) {
        self.repository = repository
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.currencies = otherCurrencies
        self.fromCurrencyRate = fromCurrencyRate
        
    }
    
    func viewDidLoad(){
        
    }
    func segmentedControlChange(to index: Int) {
        if index == 0 {
            lastDays.onNext(currencies)
        }
        else {
            self.otherCurrencies.onNext(currencies)
        }
        
    }
    func convertCurrency(firstCurrencyRate: Double, secondCurrencyRate: Double, amount: Double) -> Double{
        let result = (firstCurrencyRate / secondCurrencyRate) * amount
        return Double(round(1000 * result) / 1000)
    }
}
