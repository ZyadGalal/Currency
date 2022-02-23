//
//  DetailsRouter.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import UIKit

class DetailsRouter: BaseRouter {
    func createSceneViewController(currencyDetails: CurrencyDetails) -> UIViewController {
        let repository = DetailsRepository()
        let router = DetailsRouter()
        let detailsViewModel = DetailsViewModel(repository: repository, currencyDetails: currencyDetails)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel, router: router)
        return detailsViewController
    }

}
