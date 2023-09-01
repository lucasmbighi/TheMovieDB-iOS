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
    func favorite(mediaRequest: SaveMediaRequest) async throws -> RequestResponse
    func addToWatchList(mediaRequest: SaveMediaRequest) async throws -> RequestResponse
    func getFavoriteMovies() async throws -> RequestResponse
    func getFavoriteSeries() async throws -> RequestResponse
    func getLists() async throws -> RequestResponse
}

final class ProfileService: ProfileServiceProtocol {
    
    var client: APIClient<ProfileRequest>
    
    init(client: APIClient<Request> = .init(authPlugin: ProfilePlugin.shared)) {
        self.client = client
    }
    
    func getAccountDetails(sessionId: String) async throws -> AccountDetailResponse {
        let details: AccountDetailResponse = try await client.request(.accountDetails(sessionId: sessionId))
        return details
    }
    
    func favorite(mediaRequest: SaveMediaRequest) async throws -> RequestResponse {
        try await client.request(.favorite(mediaRequest: mediaRequest)) as RequestResponse
    }
    
    func addToWatchList(mediaRequest: SaveMediaRequest) async throws -> RequestResponse {
        try await client.request(.addToWatchList(mediaRequest: mediaRequest)) as RequestResponse
    }
    
    func getFavoriteMovies() async throws -> RequestResponse {
        try await client.request(.favoriteMovies) as RequestResponse
    }
    
    func getFavoriteSeries() async throws -> RequestResponse {
        try await client.request(.favoriteSeries) as RequestResponse
    }
    
    func getLists() async throws -> RequestResponse {
        try await client.request(.lists) as RequestResponse
    }
}

final class ProfilePlugin: AuthPluginType {
    
    static let shared = ProfilePlugin()
}
