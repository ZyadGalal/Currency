//
//  HomeRouter.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import UIKit

class HomeRouter: BaseRouter {
    func createSceneViewController() -> UIViewController {
        let repository = HomeRepository()
        let router = HomeRouter()
        let homeViewModel = HomeViewModel(repository: repository)
        let homeViewController = HomeViewController(viewModel: homeViewModel, router: router)

        return homeViewController
    }

    func createDetailsController(currencyDetails: CurrencyDetails) -> UIViewController {
        return DetailsRouter().createSceneViewController(currencyDetails: currencyDetails)
    }
}
