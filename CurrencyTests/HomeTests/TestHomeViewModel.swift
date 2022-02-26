//
//  TestHomeViewModel.swift
//  CurrencyTests
//
//  Created by Zyad Galal on 25/02/2022.
//

import XCTest
import RxSwift
import RxCocoa

@testable import Currency

class TestHomeViewModel: XCTestCase {
    var homeViewModel: HomeViewModel = HomeViewModel(repository: MockHomeRepository())

    override func setUpWithError() throws {
        homeViewModel.viewLoaded()
        homeViewModel.toPickerViewDidSelect(index: 2)
    }

    func testGetSymbol() {
        let symbol = homeViewModel.pickerItems
        XCTAssertNotEqual(symbol.value.count, 0)
    }
    
    func testGetRates() {
        let rates = homeViewModel.rates
        XCTAssertNotEqual(rates.value.count, 0)
    }
    func testGetRate() {
        // given
        let currencyName = "United States Dollar"
        //when
        let rate = homeViewModel.getRate(from: currencyName)
        //then
        XCTAssertEqual(rate, 1.11947)
    }
    func testChangeOfAmountField() {
        homeViewModel.amountValueDidChanged(to: "1234")
        XCTAssertEqual(homeViewModel.amountField.value, "1234")
    }
    func testConvertCurrency() {
        //given
        let firstRate = 17.624827
        let secondRate = 1.11947
        let USDToEGP = 15.744
        
        //when
        let convertedCurrency = 1.0.convertCurrency(firstRate: firstRate, secondRate: secondRate)
        
        // then
        XCTAssertEqual(USDToEGP, convertedCurrency)
    }
    
    func testSwap() {
        //given
        let from = homeViewModel.fromField.value
        //when
        homeViewModel.swapButtonDidClicked()
        
        //then
        let to = homeViewModel.toField.value
        XCTAssertNotEqual(from, homeViewModel.fromField.value)
        XCTAssertEqual(from, to)
    }
    
    func testGetPopularCurrencies(){
        // given
        homeViewModel.fromField = .init(value: "United States Dollar")
        
        // when
        let popularCurrencies = homeViewModel.getTenPopularCurrencies()
        
        //then
        XCTAssertFalse(popularCurrencies.keys.contains(homeViewModel.fromField.value) ? true : false)
    }
}
