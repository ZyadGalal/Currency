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

    let repository: HomeRepositoryProtocol

    var pickerItems: BehaviorRelay<[String: String]> = .init(value: [:])
    var fromField: BehaviorRelay<String> = .init(value: "")
    var toField: BehaviorRelay<String> = .init(value: "")
    var amountField: BehaviorRelay<String> = .init(value: "")
    var convertedField: BehaviorRelay<String> = .init(value: "")
    var rates: BehaviorRelay<[String: Double]> = .init(value: [:])

    init(repository: HomeRepositoryProtocol) {
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
            let toCurrencyRate = getRate(from: toField.value)
            let fromCurrencyRate = getRate(from: fromField.value)
            let convertedAmount = Double(amountField.value)!.convertCurrency(firstRate: toCurrencyRate, secondRate: fromCurrencyRate)
            convertedField.accept("\(convertedAmount)")
        }
    }
    func convertedValueDidChanged(to number: String) {
        if let numberToDouble = Double(number) {
            let fromRate = getRate(from: fromField.value)
            let toRate = getRate(from: toField.value)
            let convertedAmount = numberToDouble.convertCurrency(firstRate: fromRate, secondRate: toRate)
            convertedField.accept(number)
            amountField.accept("\(convertedAmount)")
        }
    }
    func amountValueDidChanged(to number: String) {
        if let numberToDouble = Double(number) {
            let fromRate = getRate(from: fromField.value)
            let toRate = getRate(from: toField.value)
            let convertedAmount = numberToDouble.convertCurrency(firstRate: toRate, secondRate: fromRate)
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
    func getSymbol(from field: String) -> String {
        return self.pickerItems.value.someKey(forValue: field) ?? ""
    }
    func getRate(from currencyName: String) -> Double {
        let currencySymbol = getSymbol(from: currencyName)
        return self.rates.value[currencySymbol] ?? 0.0
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
