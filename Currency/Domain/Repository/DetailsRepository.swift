//
//  DetailsRepository.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation
import RxCocoa
import RxSwift

class DetailsRepository {
    let networkClient: NetworkClient

    init (networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getHistoricalData(at date: String) -> Observable<[String: String]> {
        Observable<[String: String]>.create { [weak self] (item) -> Disposable in
            self?.networkClient.performRequest(CurrencyModel.self, router: .historicalRates(date: date, queryParameters: ["access_key": "3bd069dc60cfdc41a69f23c1344814ad"])) { result in
                switch result {
                case .success(let data):
                    if data.success == true {
                        // item.onNext(data.symbols!)
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
