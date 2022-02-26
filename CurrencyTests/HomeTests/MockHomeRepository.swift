//
//  MockHomeRepository.swift
//  CurrencyTests
//
//  Created by Zyad Galal on 25/02/2022.
//

import Foundation
import RxCocoa
import RxSwift

@testable import Currency

class MockHomeRepository: HomeRepositoryProtocol {
    func fetchRatesData() -> Observable<CurrencyModel> {
        Observable<CurrencyModel>.create { (item) -> Disposable in
            let data = self.loadJsonData(file: "RatesJSONObject")
            do {
                let response = try? JSONDecoder().decode(CurrencyModel.self, from: data!)
                if response?.success == true {
                    item.onNext(response!)
                    item.onCompleted()
                } else {
                    item.onError(CustomError.APIError(message: (response?.error?.info)!))
                }
            } catch {
                item.onError(error)
            }
            return Disposables.create()
        }
    }
    
    private func loadJsonData(file: String) -> Data? {
        //1
        if let jsonFilePath = Bundle(for: type(of:  self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            //2
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        //3
        return nil
    }
    
    func fetchSymbolsData() -> Observable<[String : String]> {
        Observable<[String: String]>.create { (item) -> Disposable in
            let data = self.loadJsonData(file: "SymbolsJSONObject")
            do {
                let response = try? JSONDecoder().decode(AllSymbolsModel.self, from: data!)
                if response?.success == true {
                    item.onNext((response?.symbols)!)
                    item.onCompleted()
                } else {
                    item.onError(CustomError.APIError(message: (response?.error?.info)!))
                }
            } catch {
                item.onError(error)
            }
            return Disposables.create()
        }

    }
    
}
