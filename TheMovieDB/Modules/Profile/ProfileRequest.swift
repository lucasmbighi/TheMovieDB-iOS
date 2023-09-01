//
//  ProfileRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

enum ProfileRequest {
    case accountDetails(sessionId: String)
    case favorite(mediaRequest: SaveMediaRequest),
         addToWatchList(mediaRequest: SaveMediaRequest)
    case favoriteMovies, favoriteSeries, lists
}

extension ProfileRequest: RequestType {
    var urlPath: String { "/account" }
    
    var method: HTTPMethod {
        switch self {
        case .accountDetails, .favoriteMovies, .favoriteSeries, .lists:
            return .get
        case .favorite, .addToWatchList:
            return .post
        }
    }
    
    var parameters: Parameter? {
        switch self {
        case .accountDetails(let sessionId):
            return .dict(["session_id": sessionId])
        case .favorite(mediaRequest: let mediaRequest), .addToWatchList(mediaRequest: let mediaRequest):
            return .dict(mediaRequest.asDictionary() ?? ["": ""])
        default:
            return nil
        }
    }
}
