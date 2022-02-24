//
//  AppDelegate.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let homeController = HomeRouter().createSceneViewController()
        let navigationController = UINavigationController(rootViewController: homeController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.sharedInstance.saveContext()
    }
}
