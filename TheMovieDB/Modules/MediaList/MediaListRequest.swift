//
//  MediaListRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

enum MediaListRequest {
    case nowPlayingMovies(page: Int),
         popularMovies(page: Int),
         topRatedMovies(page: Int),
         upcomingMovies(page: Int),
         airingTodaySeries(page: Int),
         onTheAirSeries(page: Int),
         popularSeries(page: Int),
         topRatedSeries(page: Int),
         search(type: MediaType, request: MediaListSearchRequest)
    
    var path: String {
        switch self {
        case .nowPlayingMovies: return "/3/movie/now_playing"
        case .popularMovies: return "/3/movie/popular"
        case .topRatedMovies: return "/3/movie/top_rated"
        case .upcomingMovies: return "/3/movie/upcoming"
        case .airingTodaySeries: return "/3/tv/airing_today"
        case .onTheAirSeries: return "/3/tv/on_the_air"
        case .popularSeries: return "/3/tv/popular"
        case .topRatedSeries: return "/3/tv/top_rated"
        case .search(let type, _): return type == .movie ? "/3/search/movie" : "/3/search/tv"
        }
    }
    
    init(from movieListSection: MovieListSection, page: Int) {
        switch movieListSection {
        case .nowPlaying: self = .nowPlayingMovies(page: page)
        case .popular: self = .popularMovies(page: page)
        case .topRated: self = .topRatedMovies(page: page)
        case .upcoming: self = .upcomingMovies(page: page)
        }
    }
    
    init(from serieListSection: SerieListSection, page: Int) {
        switch serieListSection {
        case .airingToday: self = .airingTodaySeries(page: page)
        case .onTheAir: self = .onTheAirSeries(page: page)
        case .popular: self = .popularSeries(page: page)
        case .topRated: self = .topRatedSeries(page: page)
        }
    }
}

extension MediaListRequest: RequestType {
    var urlPath: String { path }
    var method: HTTPMethod { .get }
    var parameters: Parameter? {
        switch self {
        case .nowPlayingMovies(let page),
                .popularMovies(let page),
                .topRatedMovies(let page),
                .upcomingMovies(let page),
                .airingTodaySeries(let page),
                .onTheAirSeries(let page),
                .popularSeries(let page),
                .topRatedSeries(let page):
            return .dict([
                "language": Locale.current.iso3166Identifier,
                "page": String(page)
            ])
        case .search(_, let request):
            return .dict(request.asDictionary() ?? ["": ""])
        }
    }
}
