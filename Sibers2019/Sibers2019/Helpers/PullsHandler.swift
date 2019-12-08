//
// Created by Igor Djachenko on 2019-05-20.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import KRPullLoader

class PullsHandler {

    private let refreshView: KRPullLoadView = KRPullLoadView()
    private let moreView: KRPullLoadView = KRPullLoadView()

    private weak var tableView: UITableView?

    private var pullViewsAddedToTable = false

    fileprivate var refreshHandler: (() -> Void)?
    fileprivate var moreHandler: (() -> Void)?

    init(table: UITableView, delegate: KRPullLoadViewDelegate) {
        tableView = table

        refreshView.delegate = delegate
        moreView.delegate = delegate
    }

    var pullHandlingNeeded = false {
        didSet {
            updatePullViews()
        }
    }

    private func updatePullViews() {
        if pullHandlingNeeded && !pullViewsAddedToTable {
            tableView?.addPullLoadableView(refreshView, type: .refresh)
            tableView?.addPullLoadableView(moreView, type: .loadMore)

            pullViewsAddedToTable = true
        }
        else if !pullHandlingNeeded && pullViewsAddedToTable {
            tableView?.removePullLoadableView(type: .refresh)
            tableView?.removePullLoadableView(type: .loadMore)

            pullViewsAddedToTable = false
        }
    }

    func finishedRefresh() {
        refreshHandler?()
        refreshHandler = nil
    }

    func finishedMore() {
        moreHandler?()
        moreHandler = nil
    }

    func set(refreshHandler handler: @escaping () -> Void) {
        refreshHandler = handler
    }

    func set(moreHandler handler: @escaping () -> Void) {
        moreHandler = handler
    }
}