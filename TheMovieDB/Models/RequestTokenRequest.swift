//
//  RequestTokenModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

struct RequestTokenRequest {
    let username: String
    let password: String
    let requestToken: String
}

extension RequestTokenRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case username, password
        case requestToken = "request_token"
    }
}
