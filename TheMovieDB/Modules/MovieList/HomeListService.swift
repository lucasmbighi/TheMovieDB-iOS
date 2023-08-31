//
//  HomeListService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

protocol HomeListServiceProtocol: ServiceType {
    associatedtype Request = HomeListRequest
    
    var client: APIClient<Request> { get set }
    
    func fetchMovieList(of section: MovieListSection, atPage page: Int) async throws -> HomeListResponse
    func fetchSerieList(of section: SerieListSection, atPage page: Int) async throws -> HomeListResponse
    func search(type: HomeListType, request: HomeListSearchRequest) async throws -> HomeListResponse
}

final class HomeListService: HomeListServiceProtocol {
    var client: APIClient<HomeListRequest>
    
    init(client: APIClient<HomeListRequest> = .init()) {
        self.client = client
    }
    
    func fetchMovieList(of section: MovieListSection, atPage page: Int) async throws -> HomeListResponse {
        return try await client.request(HomeListRequest(from: section, page: page))
    }
    
    func fetchSerieList(of section: SerieListSection, atPage page: Int) async throws -> HomeListResponse {
        return try await client.request(HomeListRequest(from: section, page: page))
    }
    
    func search(type: HomeListType, request: HomeListSearchRequest) async throws -> HomeListResponse {
        return try await client.request(.search(type: type, request: request))
    }
}
