//
//  MediaListService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

protocol MediaListServiceProtocol: ServiceType {
    associatedtype Request = MediaListRequest
    
    var client: APIClient<Request> { get set }
    
    func fetchMovieList(of section: MovieListSection, atPage page: Int) async throws -> MediaListResponse
    func fetchSerieList(of section: SerieListSection, atPage page: Int) async throws -> MediaListResponse
    func search(type: MediaType, request: MediaListSearchRequest) async throws -> MediaListResponse
}

final class MediaListService: MediaListServiceProtocol {
    var client: APIClient<MediaListRequest>
    
    init(client: APIClient<MediaListRequest> = .init()) {
        self.client = client
    }
    
    func fetchMovieList(of section: MovieListSection, atPage page: Int) async throws -> MediaListResponse {
        return try await client.request(MediaListRequest(from: section, page: page))
    }
    
    func fetchSerieList(of section: SerieListSection, atPage page: Int) async throws -> MediaListResponse {
        return try await client.request(MediaListRequest(from: section, page: page))
    }
    
    func search(type: MediaType, request: MediaListSearchRequest) async throws -> MediaListResponse {
        return try await client.request(.search(type: type, request: request))
    }
}
