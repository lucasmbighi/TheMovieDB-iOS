//
//  MovieListService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

protocol MovieListServiceProtocol: ServiceType {
    associatedtype Request = MovieListRequest
    
    var client: APIClient<Request> { get set }
    
    func fetchMovieList(of section: MovieListSection, atPage page: Int) async throws -> MovieListResponse
    func searchMovie(
        query: String,
        adult: Bool,
        language: String,
        primaryReleaseYear: String,
        region: String,
        year: String
    ) async throws -> MovieListResponse
}

final class MovieListService: MovieListServiceProtocol {
    var client: APIClient<MovieListRequest>
    
    init(client: APIClient<MovieListRequest> = .init()) {
        self.client = client
    }
    
    func fetchMovieList(of section: MovieListSection, atPage page: Int) async throws -> MovieListResponse {
        return try await client.request(MovieListRequest(from: section, page: page))
    }
    
    func searchMovie(
        query: String,
        adult: Bool,
        language: String,
        primaryReleaseYear: String,
        region: String,
        year: String
    ) async throws -> MovieListResponse {
        return try await client.request(.search(
            query: query,
            adult: adult,
            language: language,
            primaryReleaseYear: primaryReleaseYear,
            region: region,
            year: year
        ))
    }
}
