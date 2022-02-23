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
    let currencyDetails: CurrencyDetails
    var otherCurrencies = PublishSubject<[String: Double]>()
    var lastDays = PublishSubject<[String: Double]>()

    init(repository: DetailsRepository, currencyDetails: CurrencyDetails) {
        self.repository = repository
        self.currencyDetails = currencyDetails
    }
    
    func viewLoaded(){
        print("hello")
    }
    func segmentedControlChange(to index: Int) {
        if index == 0 {
            lastDays.onNext(currencyDetails.currencies)
        }
        else {
            self.otherCurrencies.onNext(currencyDetails.currencies)
        }
        
    }
    func convertCurrency(firstCurrencyRate: Double, secondCurrencyRate: Double, amount: Double) -> Double{
        let result = (firstCurrencyRate / secondCurrencyRate) * amount
        return Double(round(1000 * result) / 1000)
    }
}
