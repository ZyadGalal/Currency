//
//  DetailsRouter.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import UIKit

class DetailsRouter: BaseRouter {
    func createSceneViewController() -> UIViewController {
        let repository = DetailsRepository()
        let router = DetailsRouter()
        let detailsViewModel = DetailsViewModel(repository: repository)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel ,router: router)
        
        
        return detailsViewController
    }

}
