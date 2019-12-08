//
// Created by Igor Djachenko on 2019-05-18.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit
import KRPullLoader

protocol SingleUserViewControllerDelegate: class {
    func openGithub(user: User)
    func openGithub(repo: Repository)

    func requestedRefresh()
    func requestedMore(than: Int)
}

class SingleUserViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let headerView = UserHeaderView.bySelfNib()

    private var pullsHandler: PullsHandler?

    weak var delegate: SingleUserViewControllerDelegate?

    var user: User? {
        didSet {
            updateUserUI()
        }
    }

    var repositories: [Repository] = [] {
        didSet {
            updateRepositoriesUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "User"

        headerView?.delegate = self

        let cellNib = UINib(nibName: String(describing: RepositoryTableViewCell.self), bundle: .main)

        tableView.register(cellNib, forCellReuseIdentifier: RepositoryTableViewCell.reuseIdentifier)
        tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self

        pullsHandler = PullsHandler(table: tableView, delegate: self)

        updateUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let header = headerView else {
            return
        }

        var frame = header.frame

        frame.size.height = 150

        headerView?.frame = frame
    }

    private func updateUI() {
        updateUserUI()
        updateRepositoriesUI()
    }

    private func updateUserUI() {
        if let user = user {
            headerView?.configure(with: user)
        }
    }

    private func updateRepositoriesUI() {
        tableView.reloadData()
    }

    func finishedRefresh() {
        pullsHandler?.finishedRefresh()
    }

    func finishedMore() {
        pullsHandler?.finishedMore()
    }
}

extension SingleUserViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.reuseIdentifier, for: indexPath)

        if let repositoryCell = cell as? RepositoryTableViewCell {
            let correspondingRepository = repositories[indexPath.row]

            repositoryCell.configure(with: correspondingRepository)
        }

        return cell
    }
}

extension SingleUserViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RepositoryTableViewCell.cellHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepo = repositories[indexPath.row]

        delegate?.openGithub(repo: selectedRepo)
    }


}

extension SingleUserViewController: UserHeaderViewDelegate {
    func tappedGithubButton() {
        guard let user = user else {
            return
        }

        delegate?.openGithub(user: user)
    }
}

extension SingleUserViewController: KRPullLoadViewDelegate {
    public func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        guard case .loading(let handler) = state else {
            return
        }

        switch type {
            case .refresh:
                pullsHandler?.set(refreshHandler: handler)

                delegate?.requestedRefresh()

            case .loadMore:
                pullsHandler?.set(moreHandler: handler)

                delegate?.requestedMore(than: repositories.count)
        }
    }
}