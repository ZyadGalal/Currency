//
//  HomeViewModel.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import Foundation
import RxSwift
import RxCocoa


class HomeViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    let useCase: HomeUseCase

    var pickerItems: BehaviorRelay<[String]> = .init(value: [])
    var fromField: BehaviorRelay<String> = .init(value: "")
    var toField: BehaviorRelay<String> = .init(value: "")
    var amountField: BehaviorRelay<String> = .init(value: "")
    var convertedField: BehaviorRelay<String> = .init(value: "")
    
    lazy var fromCurrencyRate: Double = {
        return getFromFieldRate()
    }()
    
    var loading: Bool = false
    private var symbols: [String: String] = [:]
    private var rates: [String: Double] = [:]
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func viewDidLoad() {
        fetchSymbolsData()
    }
    
    func fromPickerViewDidSelect(row atIndex: Int) {
        fromField.accept(pickerItems.value[atIndex])
        if !(amountField.value.isEmpty) {
            let toCurrencyRate = getToFieldRate()
            let fromCurrencyRate = getFromFieldRate()
            
            let convertedAmount = self.convertCurrency(firstCurrencyRate: toCurrencyRate, secondCurrencyRate: fromCurrencyRate, amount: Double(amountField.value)!)
            convertedField.accept("\(convertedAmount)")
        }
    }
    func toPickerViewDidSelect(row atIndex: Int) {
        toField.accept(pickerItems.value[atIndex])
        if !(amountField.value.isEmpty) {
            let toCurrencyRate = getToFieldRate()
            let fromCurrencyRate = getFromFieldRate()
            
            let convertedAmount = self.convertCurrency(firstCurrencyRate: toCurrencyRate, secondCurrencyRate: fromCurrencyRate, amount: Double(amountField.value)!)
            convertedField.accept("\(convertedAmount)")
        }
    }
    func convertedValueDidChanged(to number: String) {
        if !(number.isEmpty) {
            let toCurrencyRate = getToFieldRate()
            let fromCurrencyRate = getFromFieldRate()
            
            let convertedAmount = self.convertCurrency(firstCurrencyRate: fromCurrencyRate, secondCurrencyRate: toCurrencyRate, amount: Double(number)!)
            convertedField.accept(number)
            amountField.accept("\(convertedAmount)")
        }
    }
    func amountValueDidChanged(to number: String) {
        if !(number.isEmpty) {
            let toCurrencyRate = getToFieldRate()
            let fromCurrencyRate = getFromFieldRate()
            
            let convertedAmount = self.convertCurrency(firstCurrencyRate: toCurrencyRate, secondCurrencyRate: fromCurrencyRate, amount: Double(number)!)
            amountField.accept(number)
            convertedField.accept("\(convertedAmount)")
        }
    }
    
    func swapButtonDidClicked() {
        let swapped = fromField.value
        fromField.accept(toField.value)
        toField.accept(swapped)
        amountValueDidChanged(to: amountField.value)
    }
    //network calls
    private func fetchSymbolsData(){
        isLoading.onNext(true)
        useCase.fetchSymbols().subscribe { [weak self] (items) in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            self.symbols = items
            
            self.pickerItems.accept(Array(items.values))
            let firstIndex = Array(items.values)[0]
            self.fromField.accept(firstIndex)
            self.toField.accept(firstIndex)

        } onError: { (error) in
            self.isLoading.onNext(false)
            self.displayError.onNext(error.localizedDescription)
            print("I got error.. \(error)")
        } onCompleted: {
            self.fetchRatesData()
            self.isLoading.onNext(false)
            
        }.disposed(by: disposeBag)

    }
    
    private func fetchRatesData(){
        isLoading.onNext(true)
        useCase.fetchCurrentRate().subscribe { [weak self] (items) in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            self.rates = items.rates!
            let firstIndex = Array(self.symbols.values)[0]
            let currency = self.symbols.someKey(forValue: firstIndex)
            let currencyRate = self.rates[currency!]!
            self.amountField.accept("1")
            let convertedAmount = self.convertCurrency(firstCurrencyRate: currencyRate, secondCurrencyRate: currencyRate, amount: Double(self.amountField.value)!)
            self.convertedField.accept("\(convertedAmount)")
        } onError: { (error) in
            self.isLoading.onNext(false)
            self.displayError.onNext(error.localizedDescription)
            print("I got error.. \(error)")
        } onCompleted: {
            self.isLoading.onNext(false)
            //
        }.disposed(by: disposeBag)

    }

    private func convertCurrency(firstCurrencyRate: Double, secondCurrencyRate: Double, amount: Double) -> Double{
        let result = (firstCurrencyRate / secondCurrencyRate) * amount
        return Double(round(1000 * result) / 1000)
    }
    private func getToFieldRate() -> Double {
        let toCurrency = self.symbols.someKey(forValue: toField.value)
        return self.rates[toCurrency!]!
    }
    private func getFromFieldRate() -> Double {
        let fromCurrency = self.symbols.someKey(forValue: fromField.value)
        return self.rates[fromCurrency!]!
    }
    func getTenOtherCurrencies() -> [String: Double] {
        var tempRates = [String: Double]()
        while (tempRates.count != 10) {
            let symbol = rates.randomElement()
            tempRates[symbol!.key] = symbol!.value
        }

        return tempRates
    }
}
