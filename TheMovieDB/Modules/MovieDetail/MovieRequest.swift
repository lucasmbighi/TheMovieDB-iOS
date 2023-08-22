//
//  MovieRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

enum MovieRequest {
    case genreList
}

extension MovieRequest: RequestType {
    var urlPath: String { "/3/genre/movie/list" }
    var method: HTTPMethod { .get }
}
