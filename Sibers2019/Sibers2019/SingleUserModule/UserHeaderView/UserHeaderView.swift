//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

protocol UserHeaderViewDelegate: class {
    func tappedGithubButton()
}

class UserHeaderView: UIView {
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var repositoriesLabel: UILabel!
    @IBOutlet private weak var githubButton: UIButton!

    @IBOutlet private weak var avatarImageView: DownloadableImage!

    weak var delegate: UserHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        githubButton.imageView?.contentMode = .scaleAspectFit
    }

    func configure(with user: User) {
        loginLabel.text = "@" + user.login
        nameLabel.text = user.name ?? ""
        repositoriesLabel.text = "\(user.repositoriesCount) repositories"

        avatarImageView.set(url: user.avatarUrl)
    }

    @IBAction private func tappedGithubButton() {
        delegate?.tappedGithubButton()
    }
}
