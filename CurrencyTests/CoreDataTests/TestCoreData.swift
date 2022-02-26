//
//  TestCoreData.swift
//  CurrencyTests
//
//  Created by Zyad Galal on 26/02/2022.
//

import XCTest
@testable import Currency

class TestCoreData: XCTestCase {
    var mockCoreData = MockCoreData()
    override func setUpWithError() throws {
    }

    func testSaveData(){
        // given
        let rates = mockCoreData.loadRatesJsonData(file: "RatesJSONObject")
        let date = "2022-02-24"
        // when
        mockCoreData.createRateEntityFrom(date: date, dictionary: (rates?.rates)!)
        mockCoreData.saveInCoreData()
        //then
        let isExist = mockCoreData.checkIfExist(date: date)
        XCTAssertEqual(isExist, true)
    }
    func testUnsavedData() {
        //given
        let date = "2022-02-25"
        //when
        let isExist = mockCoreData.checkIfExist(date: date)
        //then
        XCTAssertEqual(isExist, false)
    }
    func testFetchData() {
        //given
        let date = "2022-02-24"
        //when
        let data = mockCoreData.fetchStoredData(with: date)
        //then
        XCTAssertNotNil(data)
    }
    func testFailedToFetchData() {
        //given
        let date = "2022-02-25"
        //when
        let data = mockCoreData.fetchStoredData(with: date)
        //then
        XCTAssertNil(data)
    }
}
