//
//  DetailsViewModel.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import Foundation

class DetailsViewModel: BaseViewModel {
    
    var repository: DetailsRepository
    
    init(repository: DetailsRepository) {
        self.repository = repository
    }
}
