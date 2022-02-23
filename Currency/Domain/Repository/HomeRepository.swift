//
//  HomeRepositry.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import Foundation
import RxCocoa
import RxSwift

class HomeRepository {
    let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    func fetchSymbolsData() -> Observable<[String: String]> {
        Observable<[String: String]>.create { [weak self] (item) -> Disposable in
            self?.networkClient.performRequest(AllSymbolsModel.self, router: .supportedSymbols(queryParameters: ["access_key": "6e12c74f15086e86957b62da0b74d714"])) { (result) in
                switch result {
                case .success(let data):
                    if data.success == true {
                        item.onNext(data.symbols!)
                        item.onCompleted()
                    } else {
                        item.onError(CustomError.APIError(message: (data.error?.info)!))
                    }
                case .failure(let error):
                    item.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func fetchRatesData() -> Observable<CurrencyModel> {
        Observable<CurrencyModel>.create { [weak self] (item) -> Disposable in
            self?.networkClient.performRequest(CurrencyModel.self, router: .latest(queryParameters: ["access_key": "6e12c74f15086e86957b62da0b74d714"])) { (result) in
                switch result {
                case .success(let data):
                    if data.success == true {
                        item.onNext(data)
                        item.onCompleted()
                    } else {
                        item.onError(CustomError.APIError(message: (data.error?.info)!))
                    }
                case .failure(let error):
                    item.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func getTodayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: Date())
    }

}
