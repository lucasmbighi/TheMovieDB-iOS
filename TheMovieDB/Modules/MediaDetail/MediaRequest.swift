//
//  MediaRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

enum MediaRequest {
    case movieGenreList, serieGenreList
    case movieCredits(movieId: Int), serieCredits(serieId: Int)
}

extension MediaRequest: RequestType {
    var urlPath: String {
        switch self {
        case .movieGenreList: return "/3/genre/movie/list"
        case .serieGenreList: return "/3/genre/tv/list"
        case .movieCredits(let movieId): return "/3/movie/\(movieId)/credits"
        case .serieCredits(let serieId): return "/3/tv/\(serieId)/credits"
        }
    }
    
    var method: HTTPMethod { .get }
}
