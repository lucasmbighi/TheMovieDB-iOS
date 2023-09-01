//
//  RequestTokenModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

struct RequestTokenRequest: Encodable {
    let username: String
    let password: String
    let requestToken: String
}
