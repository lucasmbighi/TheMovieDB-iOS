//
//  MovieListRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

enum MovieListRequest {
    case nowPlaying,
         popular,
         topRated,
         upcoming,
         search(
            query: String,
            adult: Bool,
            language: String,
            primaryReleaseYear: String,
            region: String,
            year: String
         )
    
    var path: String {
        switch self {
        case .nowPlaying: return "/3/movie/now_playing"
        case .popular: return "/3/movie/popular"
        case .topRated: return "/3/movie/top_rated"
        case .upcoming: return "/3/movie/upcoming"
        case .search: return "/3/search/movie"
        }
    }
    
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
    var urlPath: String { path }
    var method: HTTPMethod { .get }
    var parameters: Parameter? {
        if case .search(let query, let adult, let language, let primaryReleaseYear, let region, let year) = self {
            return .dict([
                "query": query,
                "adult": adult,
                "language": language,
                "primary_release_year": primaryReleaseYear,
                "region": region,
                "year": year
            ])
        }
        return nil
    }
}
