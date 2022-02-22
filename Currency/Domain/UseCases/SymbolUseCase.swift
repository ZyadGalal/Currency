//
//  SymbolUseCase.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation
import RxSwift
import RxCocoa


class SymbolUseCase {
    
    let repository: HomeRepository
    let disposeBag = DisposeBag()

    init (repository: HomeRepository) {
        self.repository = repository
    }
    
    func fetchSymbols() -> Observable<[String: String]> {
        let observable = repository.fetchSymbolsData()
        observable.subscribe { [weak self] (item) in
            DispatchQueue.main.async {
                
            }
        }.disposed(by: disposeBag)

        return observable
    }
    
    
    func fetchCurrentRate() -> Observable<CurrencyModel> {
        let observable = repository.fetchRatesData()
        observable.subscribe { [weak self] (item) in
            DispatchQueue.main.async {
            }
        }.disposed(by: disposeBag)

        return observable
    }
    
}
