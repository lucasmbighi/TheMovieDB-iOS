//
//  MediaService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

protocol MediaServiceProtocol: ServiceType {
    associatedtype Request = MediaRequest
    
    var client: APIClient<Request> { get set }
    
    func getMovieGenreList() async throws -> GenreListResponse
    func getSerieGenreList() async throws -> GenreListResponse
    func getCredits(ofMovie movie: MediaResponse) async throws -> CreditListResponse
    func getCredits(ofSerie serie: MediaResponse) async throws -> CreditListResponse
}

final class MediaService: MediaServiceProtocol {
    var client: APIClient<MediaRequest>
    
    init(client: APIClient<MediaRequest> = .init()) {
        self.client = client
    }
    
    func getMovieGenreList() async throws -> GenreListResponse {
        return try await client.request(.movieGenreList)
    }
    
    func getSerieGenreList() async throws -> GenreListResponse {
        return try await client.request(.serieGenreList)
    }
    
    func getCredits(ofMovie movie: MediaResponse) async throws -> CreditListResponse {
        return try await client.request(.movieCredits(movieId: movie.id))
    }
    
    func getCredits(ofSerie serie: MediaResponse) async throws -> CreditListResponse {
        return try await client.request(.serieCredits(serieId: serie.id))
    }
}
