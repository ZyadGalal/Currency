//
//  DetailsRepository.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData




class DetailsRepository: CoreDataFunctionality {
    
    let networkClient: NetworkClient

    init (networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getHistoricalData(at date: String) -> Observable<CurrencyModel> {
        Observable<CurrencyModel>.create { [weak self] (item) -> Disposable in
            if self!.checkIfExist(date: date) {
                if let rates = self?.fetchStoredData(with: date) {
                    DispatchQueue.main.async {
                        item.onNext(rates)
                        item.onCompleted()
                    }
                }
            }
            else {
                self?.fetchHistoricalRatesFromAPI(date: date) {[weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let response):
                        if response.success == true {
                            if let _ = self.createRateEntityFrom(date: date, dictionary: response.rates!) {
                                self.saveInCoreData()
                                item.onNext(response)
                            } else {
                                item.onError(CustomError.APIError(message: "can't save data"))
                            }
                        } else {
                            if response.error?.code == 104 {
                                self.networkClient.cancelRequests()
                            }
                            item.onError(CustomError.APIError(message: (response.error?.info)!))
                        }
                    case .failure(let error):
                        item.onError(error)
                    }
                }
            }
                return Disposables.create()
        }
        
    }
    
    private func fetchHistoricalRatesFromAPI (date: String, completion: @escaping ((Result<CurrencyModel, Error>) -> Void)) {
        networkClient.performRequest(CurrencyModel.self, router: .historicalRates(date: date), completion: completion)
    }
    
    

}
