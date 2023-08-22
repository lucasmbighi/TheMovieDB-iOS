//
//  MovieListRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

enum MovieListRequest: String {
    case nowPlaying = "now_playing", popular, topRated = "top_rated", upcoming
    
    init(from movieListSection: MovieListSection) {
        switch movieListSection {
        case .nowPlaying: self = .nowPlaying
        case .popular: self = .popular
        case .topRated: self = .topRated
        case .upcoming: self = .upcoming
        }
    }
}

extension MovieListRequest: RequestType {
    var urlPath: String { "/3/movie/\(rawValue)" }
    var method: HTTPMethod { .get }
}
