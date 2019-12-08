//
// Created by Igor Djachenko on 2019-05-18.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation
import UIKit

class UserPreviewTableViewCell: UITableViewCell {
    static let reuseIdentifier = "UserPreviewTableViewCell"
    static let cellHeight: CGFloat = 60

    @IBOutlet private weak var avatarView: DownloadableImage!
    @IBOutlet private weak var loginLabel: UILabel!


    func configure(user: UserPreview) {
        avatarView.set(url: user.avatarUrl)
        loginLabel.text = user.login
    }
}
