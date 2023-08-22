//
//  RequestTokenModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

struct RequestTokenResponse {
    let success: Bool
    let expiresAt: String
    let requestToken: String
}

extension RequestTokenResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
