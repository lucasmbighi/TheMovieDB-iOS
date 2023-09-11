//
//  RequestResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 01/09/23.
//

import Foundation

struct RequestResponse: Decodable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
}
