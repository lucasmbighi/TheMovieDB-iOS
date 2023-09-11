//
//  AuthService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

protocol ProfileServiceProtocol: ServiceType {
    associatedtype Request = ProfileRequest
    
    var client: APIClient<Request> { get set }
    
    func getAccountDetails(sessionId: String) async throws -> AccountDetailResponse
    func favorite(accountId: Int, mediaRequest: SaveMediaRequest) async throws -> RequestResponse
    func getFavoriteMovies(accountId: Int) async throws -> MediaListResponse
    func getFavoriteSeries(accountId: Int) async throws -> MediaListResponse
    func createList(sessionId: String, request: CreateListRequest) async throws -> CreateListResponse
    func addToWatchList(accountId: Int, mediaRequest: SaveMediaRequest) async throws -> RequestResponse
    func getLists(accountId: Int) async throws -> ListsResponse
    func addToList(_ list: ListResponse, media: MediaResponse, sessionId: String) async throws -> RequestResponse
    func deleteList(_ list: ListResponse, sessionId: String) async throws -> RequestResponse
}

final class ProfileService: ProfileServiceProtocol {
    
    var client: APIClient<ProfileRequest>
    
    init(client: APIClient<Request> = .init()) {
        self.client = client
    }
    
    func getAccountDetails(sessionId: String) async throws -> AccountDetailResponse {
        let details: AccountDetailResponse = try await client.request(.accountDetails(sessionId: sessionId))
        return details
    }
    
    func favorite(accountId: Int, mediaRequest: SaveMediaRequest) async throws -> RequestResponse {
        try await client.request(.favorite(accountId: accountId, mediaRequest: mediaRequest)) as RequestResponse
    }
    
    func getFavoriteMovies(accountId: Int) async throws -> MediaListResponse {
        try await client.request(.favoriteMovies(accountId: accountId)) as MediaListResponse
    }
    
    func getFavoriteSeries(accountId: Int) async throws -> MediaListResponse {
        try await client.request(.favoriteSeries(accountId: accountId)) as MediaListResponse
    }
    
    func createList(sessionId: String, request: CreateListRequest) async throws -> CreateListResponse {
        try await client.request(.createList(sessionId: sessionId, request: request)) as CreateListResponse
    }
    
    func addToWatchList(accountId: Int, mediaRequest: SaveMediaRequest) async throws -> RequestResponse {
        try await client.request(.addToWatchList(accountId: accountId, mediaRequest: mediaRequest)) as RequestResponse
    }
    
    func getLists(accountId: Int) async throws -> ListsResponse {
        try await client.request(.lists(accountId: accountId)) as ListsResponse
    }
    
    func addToList(_ list: ListResponse, media: MediaResponse, sessionId: String) async throws -> RequestResponse {
        try await client.request(.addToList(list, media: media, sessionId: sessionId)) as RequestResponse
    }
    
    func deleteList(_ list: ListResponse, sessionId: String) async throws -> RequestResponse {
        try await client.request(.deleteList(list, sessionId: sessionId)) as RequestResponse
    }
}
