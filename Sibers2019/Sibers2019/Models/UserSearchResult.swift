//
// Created by Igor Djachenko on 2019-05-18.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation

struct UserSearchResult: Decodable {
    let items: [UserPreview]
    let totalCount: Int

    private enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
}
