//
//  MockDetailsViewModel.swift
//  CurrencyTests
//
//  Created by Zyad Galal on 26/02/2022.
//

import Foundation
@testable import Currency

class MockCoreData: CoreDataFunctionality {
    func loadRatesJsonData(file: String) -> CurrencyModel? {
        //1
        if let jsonFilePath = Bundle(for: type(of:  self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            //2
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                let data = try! JSONDecoder().decode(CurrencyModel.self, from: jsonData)
                return data
            }
        }
        //3
        return nil
    }
}
