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
    func getSerieGenreList() async throws -> GenreListResponse
    func getCredits(ofMovie movie: MovieResponse) async throws -> CreditListResponse
    func getCredits(ofSerie serie: MovieResponse) async throws -> CreditListResponse
}

final class MovieService: MovieServiceProtocol {
    var client: APIClient<MovieRequest>
    
    init(client: APIClient<MovieRequest> = .init()) {
        self.client = client
    }
    
    func getMovieGenreList() async throws -> GenreListResponse {
        return try await client.request(.movieGenreList)
    }
    
    func getSerieGenreList() async throws -> GenreListResponse {
        return try await client.request(.serieGenreList)
    }
    
    func getCredits(ofMovie movie: MovieResponse) async throws -> CreditListResponse {
        return try await client.request(.movieCredits(movieId: movie.id), keyDecodingStrategy: .convertFromSnakeCase)
    }
    
    func getCredits(ofSerie serie: MovieResponse) async throws -> CreditListResponse {
        return try await client.request(.serieCredits(serieId: serie.id), keyDecodingStrategy: .convertFromSnakeCase)
    }
}
