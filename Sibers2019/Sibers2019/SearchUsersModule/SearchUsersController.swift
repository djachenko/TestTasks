//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

class SearchUsersController: BaseController {
    private weak var viewController: SearchUsersViewController?

    private var currentUsers: [UserPreview] = []
    private var maxUserCount = 0

    override init(navigator: UINavigationController, api: GithubApi) {
        super.init(navigator: navigator, api: api)

        failureHandler = { [weak self] message in
            DispatchQueue.main.async {
                self?.viewController?.handle(error: message)
            }
        }
    }

    override func createViewController() -> BaseViewController {
        let viewController = SearchUsersViewController()
        viewController.delegate = self

        self.viewController = viewController

        return viewController
    }
}

extension SearchUsersController: SearchUsersViewControllerDelegate {
    private func getUsersFromScratch(query: String, finalizer: (()->Void)? = nil) {
        if query.isEmpty {
            currentUsers = []

            self.viewController?.users = currentUsers

            finalizer?()
        }
        else {
            api.searchUsers(query: query,
                    success: { [weak self] newUsers, maxCount in
                        self?.currentUsers = newUsers
                        self?.maxUserCount = maxCount

                        DispatchQueue.main.async {
                            guard let self = self else {
                                return
                            }

                            self.viewController?.users = self.currentUsers

                            finalizer?()
                        }
                    },
                    failure: failureHandler
            )
        }
    }

    func updated(query: String) {
        getUsersFromScratch(query: query)
    }

    func selected(user: UserPreview) {
        let singleController = SingleUserController(navigator: navigator, api: api, username: user.login)

        singleController.show()
    }

    func requestedRefresh(for query: String) {
        getUsersFromScratch(query: query) { [weak self] in
            self?.viewController?.finishedRefresh()
        }
    }

    func requestedMore(of query: String) {
        if currentUsers.count == maxUserCount {
            self.viewController?.finishedMore()
        }
        else {
            api.searchUsers(query: query,
                    startingFrom: currentUsers.count,
                    success: { [weak self] newUsers, _ in
                        self?.currentUsers.append(contentsOf: newUsers)

                        DispatchQueue.main.async {
                            guard let self = self else {
                                return
                            }

                            self.viewController?.users = self.currentUsers

                            self.viewController?.finishedMore()
                        }
                    },
                    failure: failureHandler
            )
        }
    }
}
