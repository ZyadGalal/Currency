//
//  HomeViewModel.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol output {
    var price: Observable<String> { get }
}
class HomeViewModel: BaseViewModel, output {
    
    let repository: HomeRepository
    var price: Observable<String>
    var pickerItems: Observable<[String]>
    
    var loading: Bool = false
    private var prices: BehaviorRelay<String> = .init(value: "zyad")
    private let items: Observable<[String]> = Observable.of(["Row1", "Row2", "Row3"])
    init(repository: HomeRepository) {
        self.price = prices.asObservable()
        self.pickerItems = items
        self.repository = repository
    }
    
    func viewDidLoad() {
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(setPrice), userInfo: nil, repeats: true)
    }
    
    @objc func setPrice() {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          
        prices.accept(String((0..<4).map{ _ in letters.randomElement()! }))
        loading = loading ? false : true
        isLoading.onNext(loading)
    }
    func fromTextFieldDataChanged(with string: String) {
        print(string)
    }
    func toTextFieldDataChanged(with string: String) {
        print(string)
    }
}
