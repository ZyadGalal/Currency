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
    
    var lastDaysCurrency: BehaviorRelay<[CurrencyModel]> = .init(value: [])
    private var lastDaysRates: BehaviorRelay<[CurrencyModel]> = .init(value: [])
    private var page: BehaviorRelay<Int> = .init(value: 0)
    init(repository: DetailsRepository, currencyDetails: CurrencyDetails) {
        self.repository = repository
        self.currencyDetails = currencyDetails
    }
    
    func viewLoaded() {
        
        lastDaysRates.subscribe (onNext:{ _ in
            if self.lastDaysRates.value.count == 30 {
                self.isLoading.onNext(false)
            }
            
            let sortedDays = self.lastDaysRates.value.sorted(by: { Date().getDateFrom(string: $0.date!).compare(Date().getDateFrom(string: $1.date!)) == .orderedDescending })
            self.lastDaysCurrency.accept(sortedDays)
            
        }).disposed(by: disposeBag)
        
        loadLast30Days()
    }
    func segmentedControlChange(to index: Int) {
        if index == 0 {
            self.lastDaysCurrency.accept(lastDaysRates.value)
        } else {
            self.otherCurrencies.onNext(currencyDetails.currenciesRates)
        }
    }
    func convertCurrency(firstCurrencyRate: Double, secondCurrencyRate: Double, amount: Double) -> Double {
        let result = (firstCurrencyRate / secondCurrencyRate) * amount
        return Double( round(1000 * result) / 1000 )
    }
    func loadLast30Days() {
        isLoading.onNext(true)
        for counter in 1 ..< 31 {
            DispatchQueue.global().async {
                self.repository.getHistoricalData(at: Date().getDayDate(before: counter)).subscribe{ [weak self] item in
                    guard let self = self else {return}
                    var array = self.lastDaysRates.value
                    array.append(item)
                    self.lastDaysRates.accept(array)
                }onError: { errors in
                    self.isLoading.onNext(false)
                    self.displayError.onNext(errors.localizedDescription)
                }.disposed(by: self.disposeBag)
            }
        }
    }
}
