//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation

struct User: Decodable {
    let login: String
    let name: String?
    let repositoriesCount: Int
    let avatarUrl: URL
    let htmlUrl: URL

    private enum CodingKeys: String, CodingKey {
        case login
        case name
        case repositoriesCount = "public_repos"
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}
