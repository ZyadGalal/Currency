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

    let repository: HomeRepository

    var pickerItems: BehaviorRelay<[String: String]> = .init(value: [:])
    var fromField: BehaviorRelay<String> = .init(value: "")
    var toField: BehaviorRelay<String> = .init(value: "")
    var amountField: BehaviorRelay<String> = .init(value: "")
    var convertedField: BehaviorRelay<String> = .init(value: "")
    private var rates: BehaviorRelay<[String: Double]> = .init(value: [:])

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func viewLoaded() {
        fetchSymbolsData()
    }

    func fromPickerViewDidSelect(index: Int) {
        let symbol = Array(pickerItems.value.values)[index]
        fromField.accept(symbol)
        pickerViewItemSelected()
    }
    func toPickerViewDidSelect(index: Int) {
        let symbol = Array(pickerItems.value.values)[index]
        toField.accept(symbol)
        pickerViewItemSelected()
    }
    func pickerViewItemSelected() {
        if !(amountField.value.isEmpty) {
            let toCurrencyRate = getToFieldRate()
            let fromCurrencyRate = getFromFieldRate()
            let convertedAmount = Double(amountField.value)!.convertCurrency(firstRate: toCurrencyRate, secondRate: fromCurrencyRate)
            convertedField.accept("\(convertedAmount)")
        }
    }
    func convertedValueDidChanged(to number: String) {
        if !(number.isEmpty) {
            let convertedAmount = Double(number)!.convertCurrency(firstRate: getFromFieldRate(), secondRate: getToFieldRate())
            convertedField.accept(number)
            amountField.accept("\(convertedAmount)")
        }
    }
    func amountValueDidChanged(to number: String) {
        if !(number.isEmpty) {
            let convertedAmount = Double(number)!.convertCurrency(firstRate: getToFieldRate(), secondRate: getFromFieldRate())
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
    // network calls
    private func fetchSymbolsData() {
        isLoading.onNext(true)
        repository.fetchSymbolsData().subscribe { [weak self] (items) in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            self.pickerItems.accept(items)
            let firstIndex = Array(items.values)[0]
            self.fromField.accept(firstIndex)
            self.toField.accept(firstIndex)

        } onError: { (error) in
            self.isLoading.onNext(false)
            self.displayError.onNext(error.localizedDescription)
            print("I got error.. \(error)")
        } onCompleted: {
            self.isLoading.onNext(false)
            self.fetchRatesData()
        }.disposed(by: disposeBag)
    }

    private func fetchRatesData() {
        isLoading.onNext(true)
        repository.fetchRatesData().subscribe { [weak self] (items) in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            self.rates.accept(items.rates!)
            let firstIndex = Array(self.pickerItems.value.values)[0]
            let currency = self.pickerItems.value.someKey(forValue: firstIndex)
            let currencyRate = self.rates.value[currency!]!
            self.amountField.accept("1")
            let convertedAmount = Double(self.amountField.value)!.convertCurrency(firstRate: currencyRate, secondRate: currencyRate)

            self.convertedField.accept("\(convertedAmount)")
        } onError: { (error) in
            self.isLoading.onNext(false)
            self.displayError.onNext(error.localizedDescription)
            print("I got error.. \(error)")
        } onCompleted: {
            self.isLoading.onNext(false)
        }.disposed(by: disposeBag)

    }

    private func getToFieldRate() -> Double {
        let toCurrency = self.pickerItems.value.someKey(forValue: toField.value)
        return self.rates.value[toCurrency!]!
    }
    func getFromFieldRate() -> Double {
        let fromCurrency = self.pickerItems.value.someKey(forValue: fromField.value)
        return self.rates.value[fromCurrency!]!
    }
    func getTenOtherCurrencies() -> [String: Double] {
        var tempRates = [String: Double]()
        while tempRates.count != 10 {
            let symbol = rates.value.randomElement()
            tempRates[symbol!.key] = symbol!.value
        }

        return tempRates
    }
}
