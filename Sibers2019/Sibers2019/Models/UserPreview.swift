//
// Created by Igor Djachenko on 2019-05-18.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation

struct UserPreview: Decodable {
    let login: String
    let avatarUrl: URL

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
