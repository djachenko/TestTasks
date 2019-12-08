//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

class SingleUserController: BaseController {
    private var username: String

    private var user: User?
    private var currentRepositories: [Repository] = []

    private weak var viewController: SingleUserViewController?


    init(navigator: UINavigationController, api: GithubApi, username: String) {
        self.username = username

        super.init(navigator: navigator, api: api)

        failureHandler = { [weak self] message in
            DispatchQueue.main.async {
                self?.viewController?.handle(error: message)
            }
        }
    }

    override func createViewController() -> BaseViewController {
        let vc = SingleUserViewController()
        vc.delegate = self

        viewController = vc

        api.get(user: username,
                success: { [weak self] user in
                    self?.user = user

                    DispatchQueue.main.async {
                        self?.viewController?.user = user
                    }
                },
                failure: failureHandler
        )

        api.repos(user: username,
                success: { [weak self] repositories in
                    self?.currentRepositories = repositories

                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }

                        self.viewController?.repositories = self.currentRepositories
                    }
                },
                failure: failureHandler
        )

        return vc
    }
}

extension SingleUserController: SingleUserViewControllerDelegate {
    private func open(link: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(link)
        }
        else {
            UIApplication.shared.openURL(link)
        }
    }

    func openGithub(user: User) {
        open(link: user.htmlUrl)
    }

    func openGithub(repo: Repository) {
        open(link: repo.htmlUrl)
    }

    func requestedRefresh() {
        api.repos(user: username,
                success: { [weak self] repositories in
                    self?.currentRepositories = repositories

                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }

                        self.viewController?.repositories = self.currentRepositories

                        self.viewController?.finishedRefresh()
                    }
                },
                failure: failureHandler
        )
    }

    func requestedMore(than: Int) {
        if currentRepositories.count == user?.repositoriesCount {
            viewController?.finishedMore()
        }
        else {
            api.repos(user: username,
                    startingFrom: than,
                    success: { [weak self] newRepositories in

                        self?.currentRepositories.append(contentsOf: newRepositories)

                        DispatchQueue.main.async {
                            guard let self = self else {
                                return
                            }

                            self.viewController?.repositories = self.currentRepositories

                            self.viewController?.finishedMore()
                        }
                    },
                    failure: failureHandler
            )
        }
    }
}
