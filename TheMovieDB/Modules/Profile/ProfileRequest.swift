//
//  ProfileRequest.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

enum ProfileRequest {
    case accountDetails(sessionId: String),
         favorite(accountId: Int, mediaRequest: SaveMediaRequest),
         addToWatchList(accountId: Int, mediaRequest: SaveMediaRequest),
         favoriteMovies(accountId: Int),
         favoriteSeries(accountId: Int),
         lists(accountId: Int),
         createList(sessionId: String, request: CreateListRequest),
         addToList(_ list: ListResponse, media: MediaResponse, sessionId: String),
         deleteList(_ list: ListResponse, sessionId: String)
}

extension ProfileRequest: RequestType {
    var urlPath: String {
        switch self {
        case .accountDetails:
            return "/3/account"
        case .favorite(let accountId, _):
            return "/3/account/\(accountId)/favorite"
        case .addToWatchList(let accountId, _):
            return "/3/account/\(accountId)/watchlist"
        case .favoriteMovies(let accountId):
            return "/3/account/\(accountId)/favorite/movies"
        case .favoriteSeries(let accountId):
            return "/3/account/\(accountId)/favorite/tv"
        case .lists(let accountId):
            return "/3/account/\(accountId)/lists"
        case .createList:
            return "/3/list"
        case .addToList(let list, _, _):
            return "/3/list/\(list.id)/add_item"
        case .deleteList(let list, _):
            return "/3/list/\(list.id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .accountDetails, .favoriteMovies, .favoriteSeries, .lists:
            return .get
        case .favorite, .addToWatchList, .createList, .addToList:
            return .post
        case .deleteList:
            return .delete
        }
    }
    
    var parameters: Parameter? {
        switch self {
        case .accountDetails(let sessionId), .deleteList(_, let sessionId):
            return .dict(["session_id": sessionId])
        case .favorite(_, let mediaRequest), .addToWatchList(_, let mediaRequest):
            return .encodable(mediaRequest)
        case .createList(let sessionId, let createListequest):
            return .both(queryItems: ["session_id": sessionId], body: createListequest)
        case .addToList(_, let media, let sessionId):
            return .both(queryItems: ["session_id": sessionId], body: ["media_id" : media.id])
        default:
            return nil
        }
    }
}
