//
//  Movie.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

struct MovieResponse: Identifiable, Hashable {
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let overview: String
    let posterPath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double
}

extension MovieResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case genreIds = "genre_ids"
        case id, title, overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }
}
