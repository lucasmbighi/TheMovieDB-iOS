//
//  MovieListResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

struct MovieListResponse: Decodable {
    let page: Int
    let results: [MovieResponse]
}
