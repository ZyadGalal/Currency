//
//  DetailsRouter.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import UIKit

class DetailsRouter: BaseRouter {
    func createSceneViewController(fromCurrency: String, toCurrency: String, otherCurrencies: [String: Double]) -> UIViewController {
        let repository = DetailsRepository()
        let router = DetailsRouter()
        let detailsViewModel = DetailsViewModel(repository: repository, fromCurrency: fromCurrency, toCurrency: toCurrency, otherCurrencies: otherCurrencies)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel ,router: router)
        
        
        return detailsViewController
    }

}
