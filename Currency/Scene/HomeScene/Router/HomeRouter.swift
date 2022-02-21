//
//  HomeRouter.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import UIKit

class HomeRouter {
    class func createHomeViewController() -> UIViewController{
        let repository = HomeRepository()
        let homeViewModel = HomeViewModel(repository: repository)
        let HomeViewController = HomeViewController(viewModel: homeViewModel)
        
        
        return HomeViewController
    }
    
}
