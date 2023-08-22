//
//  GenreListResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

struct GenreListResponse: Decodable {
    let genres: [GenreResponse]
}
