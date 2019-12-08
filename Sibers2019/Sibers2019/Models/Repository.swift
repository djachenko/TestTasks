//
// Created by Igor Djachenko on 2019-05-19.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let language: String?
    let description: String?
    let htmlUrl: URL

    private enum CodingKeys: String, CodingKey {
        case name
        case language
        case description
        case htmlUrl = "html_url"
    }
}
