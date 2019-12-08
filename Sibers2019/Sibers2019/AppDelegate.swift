//
//  AppDelegate.swift
//  sibers-test
//
//  Created by Igor Djachenko on 17/05/2019.
//  Copyright © 2019 Igor Djachenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController()

        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.backgroundColor = .black

        window?.rootViewController = navigationController

        let api = GithubApi()

        let searchController = SearchUsersController(navigator: navigationController, api: api)

        searchController.show()

        window?.makeKeyAndVisible()

        return true
    }
}

