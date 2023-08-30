//
//  CreditListResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 30/08/23.
//

import Foundation

struct CreditListResponse: Decodable {
    let id: Int
    let cast: [CastResponse]
}

//MARK: Static properties
extension CreditListResponse {
    static let empty = CreditListResponse(id: 0, cast: [CastResponse]())
}
