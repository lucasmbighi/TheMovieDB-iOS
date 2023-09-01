//
//  RequestTokenModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

struct RequestTokenResponse: Decodable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
}
