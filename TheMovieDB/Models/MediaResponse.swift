//
//  MediaResponse.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

struct MediaResponse: Identifiable, Hashable, Decodable {
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
extension MediaResponse {
    static let empty = MediaResponse(
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
