//
//  BaseViewModel.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    var isLoading: PublishSubject<Bool> {get set}
    var displayError: PublishSubject<String> {get set}

}

class BaseViewModel: ViewModelProtocol {
    var isLoading: PublishSubject<Bool> = .init()
    var displayError: PublishSubject<String> = .init()
    let disposeBag = DisposeBag()

}
