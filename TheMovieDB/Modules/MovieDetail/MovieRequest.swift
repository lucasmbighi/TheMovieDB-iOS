//
//  MovieRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

enum MovieRequest {
    case genreList
    case credits(movieId: Int)
}

extension MovieRequest: RequestType {
    var urlPath: String {
        switch self {
        case .genreList:
            return "/3/genre/movie/list"
        case .credits(let movieId):
            return "/3/movie/\(movieId)/credits"
        }
    }
    
    var method: HTTPMethod { .get }
}
