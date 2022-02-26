//
//  HomeRepositry.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeRepositoryProtocol {
    func fetchSymbolsData() -> Observable<[String: String]>
    func fetchRatesData() -> Observable<CurrencyModel>
}

class HomeRepository: HomeRepositoryProtocol {
    let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    func fetchSymbolsData() -> Observable<[String: String]> {
        Observable<[String: String]>.create { [weak self] (item) -> Disposable in
            self?.networkClient.performRequest(AllSymbolsModel.self, router: .supportedSymbols) { (result) in
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
            self?.networkClient.performRequest(CurrencyModel.self, router: .latest) { (result) in
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
}
