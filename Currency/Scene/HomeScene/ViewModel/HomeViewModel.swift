//
//  HomeViewModel.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import Foundation


class HomeViewModel: BaseViewModel {
    
    let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
}
