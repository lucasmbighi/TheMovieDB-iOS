//
//  AccountDetailResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

struct AccountDetailResponse {
    let accountId: Int
}

extension AccountDetailResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case accountId = "id"
    }
}
