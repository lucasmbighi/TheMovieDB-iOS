//
//  MediaListResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

struct MediaListResponse: Decodable {
    let page: Int
    let results: [MediaResponse]
    let totalPages: Int
    let totalResults: Int
}
