//
//  Movie.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

struct MovieResponse: Identifiable, Hashable {
    let backdropPath: String?
    let firstAirDate: String?
    let genreIds: [Int]
    let id: Int
    let name: String?
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double
}

//MARK: Static properties
extension MovieResponse {
    static let empty = MovieResponse(
        backdropPath: nil,
        firstAirDate: nil,
        genreIds: [Int](),
        id: 0,
        name: nil,
        overview: "",
        posterPath: "",
        releaseDate: "",
        title: "",
        voteAverage: 0
    )
}

//MARK: Decodable
extension MovieResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case firstAirDate = "first_air_date"
        case genreIds = "genre_ids"
        case id, title, name, overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }
}
