//
//  SearchUsersViewController.swift
//  sibers-test
//
//  Created by Igor Djachenko on 17/05/2019.
//  Copyright © 2019 Igor Djachenko. All rights reserved.
//

import UIKit
import KRPullLoader

protocol SearchUsersViewControllerDelegate: class {
    func updated(query: String)

    func selected(user: UserPreview)

    func requestedRefresh(for query: String)
    func requestedMore(of query: String)
}

class SearchUsersViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    @IBOutlet private weak var searchSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var searchBarOverlay: UIView!

    weak var delegate: SearchUsersViewControllerDelegate?

    private var pullsHandler: PullsHandler?

    var users: [UserPreview] = [] {
        didSet {
            updateUI()

            set(searchInProgress: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: String(describing: UserPreviewTableViewCell.self), bundle: .main)

        tableView.register(cellNib, forCellReuseIdentifier: UserPreviewTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        searchBar.delegate = self

        pullsHandler = PullsHandler(table: tableView, delegate: self)

        set(searchInProgress: false)

        title = "Users"
    }

    private func set(searchInProgress: Bool) {
        searchBar.isUserInteractionEnabled = !searchInProgress
        searchBarOverlay.isHidden = !searchInProgress

        if searchInProgress {
            searchSpinner.startAnimating()
        }
        else {
            searchSpinner.stopAnimating()
        }
    }

    private func updateUI() {
        tableView.reloadData()

        pullsHandler?.pullHandlingNeeded = !users.isEmpty
    }

    func finishedRefresh() {
        pullsHandler?.finishedRefresh()
    }

    func finishedMore() {
        pullsHandler?.finishedMore()
    }

    override func handle(error message: String) {
        super.handle(error: message)

        set(searchInProgress: false)
    }
}

extension SearchUsersViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserPreviewTableViewCell.reuseIdentifier, for: indexPath)

        if let userCell = cell as? UserPreviewTableViewCell {
            let user = users[indexPath.row]

            userCell.configure(user: user)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

extension SearchUsersViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(user: users[indexPath.row])
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserPreviewTableViewCell.cellHeight
    }
}

extension SearchUsersViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        let query = searchBar.text ?? ""

        set(searchInProgress: true)

        delegate?.updated(query: query.lowercased())
    }
}

extension SearchUsersViewController: KRPullLoadViewDelegate {
    public func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        guard case .loading(let handler) = state else {
            return
        }

        guard let query = searchBar.text else {
            return
        }

        switch type {
            case .refresh:
                pullsHandler?.set(refreshHandler: handler)

                delegate?.requestedRefresh(for: query)

            case .loadMore:
                pullsHandler?.set(moreHandler: handler)

                delegate?.requestedMore(of: query)
        }
    }
}

