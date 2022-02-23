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
        let useCase = HomeUseCase(repository: repository)
        let router = HomeRouter()
        let homeViewModel = HomeViewModel(useCase: useCase)
        let HomeViewController = HomeViewController(viewModel: homeViewModel, router: router)
        
        return HomeViewController
    }

    func createDetailsController(fromCurrency: String, fromCurrencyRate: Double, toCurrency: String, otherCurrencies: [String: Double]) -> UIViewController{
        return DetailsRouter().createSceneViewController(fromCurrency: fromCurrency, fromCurrencyRate: fromCurrencyRate, toCurrency: toCurrency, otherCurrencies: otherCurrencies)
    }
}
