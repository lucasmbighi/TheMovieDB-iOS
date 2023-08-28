//
//  MovieListRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

enum MovieListRequest {
    case nowPlaying(page: Int),
         popular(page: Int),
         topRated(page: Int),
         upcoming(page: Int),
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
    
    init(from movieListSection: MovieListSection, page: Int) {
        switch movieListSection {
        case .nowPlaying: self = .nowPlaying(page: page)
        case .popular: self = .popular(page: page)
        case .topRated: self = .topRated(page: page)
        case .upcoming: self = .upcoming(page: page)
        }
    }
}

extension MovieListRequest: RequestType {
    var urlPath: String { path }
    var method: HTTPMethod { .get }
    var parameters: Parameter? {
        switch self {
        case .nowPlaying(let page), .popular(let page), .topRated(let page), .upcoming(let page):
            return .dict(["page": String(page)])
        case .search(let query, let adult, let language, let primaryReleaseYear, let region, let year):
            return .dict([
                "query": query,
                "adult": String(adult),
                "language": language,
                "primary_release_year": primaryReleaseYear,
                "region": region,
                "year": year
            ])
        }
    }
}
