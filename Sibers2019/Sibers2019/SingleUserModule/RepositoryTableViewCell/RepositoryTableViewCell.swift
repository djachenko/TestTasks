//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

class RepositoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RepositoryTableViewCell"
    static let cellHeight: CGFloat = 112

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!


    func configure(with repository: Repository) {
        var title = repository.name

        if let language = repository.language {
            title += " (\(language))"
        }

        titleLabel.text = title

        descriptionLabel.text = repository.description ?? "No description"
    }
}
