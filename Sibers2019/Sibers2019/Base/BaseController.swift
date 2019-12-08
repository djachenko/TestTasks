//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

class BaseController {
    let navigator: UINavigationController
    let api: GithubApi

    var failureHandler: (String) -> Void = { _ in }

    init(navigator: UINavigationController, api: GithubApi) {
        self.navigator = navigator
        self.api = api
    }

    func show() {
        let viewController = createViewController()

        viewController.controller = self

        navigator.pushViewController(viewController, animated: true)
    }

    func createViewController() -> BaseViewController {
        fatalError("createViewController() has not been implemented")
    }
}
