//
//  MovieService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

protocol MovieServiceProtocol: ServiceType {
    associatedtype Request = MovieRequest
    
    var client: APIClient<Request> { get set }
    
    func getMovieGenreList() async throws -> GenreListResponse
}

final class MovieService: MovieServiceProtocol {
    var client: APIClient<MovieRequest>
    
    init(client: APIClient<MovieRequest> = .init()) {
        self.client = client
    }
    
    func getMovieGenreList() async throws -> GenreListResponse {
        return try await client.request(.genreList)
    }
}
