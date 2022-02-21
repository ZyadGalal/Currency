//
//  BaseViewModel.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModel {
    
}

class BaseViewModel: ViewModel {
    var isLoading: PublishSubject<Bool> = .init()
    var displayError: PublishSubject<String> = .init()
    
    
}
