//
//  MovieListResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

struct MovieListResponse {
    let page: Int
    let results: [MovieResponse]
    let totalPages: Int
    let totalResults: Int
}

extension MovieListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case page, results,
             totalPages = "total_pages",
             totalResults = "total_results"
    }
}
