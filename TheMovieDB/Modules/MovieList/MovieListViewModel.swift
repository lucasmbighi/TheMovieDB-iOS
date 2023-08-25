//
//  MovieListViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

protocol MovieListViewModelProtocol {
    var sections: [MovieListSection] { get }
    var selectedSection: MovieListSection { get set }
    var isSearching: Bool { get set }
    var searchQuery: String { get set }
    var adult: Bool { get set }
    var availableYears: [String] { get set }
    var primaryReleaseYear: String { get set }
    var year: String { get set }
    
    var moviesList: MovieListResponse? { get set }
    var errorMessage: String? { get set }
    var service: any MovieListServiceProtocol { get set }
    
    init(service: any MovieListServiceProtocol)
    
    func isSelected(_ section: MovieListSection) -> Bool
    @MainActor func fetchMovieList() async
    @MainActor func search() async
}

extension MovieListViewModelProtocol {
    var sections: [MovieListSection] { MovieListSection.allCases }
    
    func isSelected(_ section: MovieListSection) -> Bool { selectedSection == section }
}

final class MovieListViewModel: MovieListViewModelProtocol, ObservableObject {
    
    @Published var selectedSection: MovieListSection = .nowPlaying
    @Published var isSearching: Bool = false
    @Published var searchQuery: String = ""
    @Published var adult: Bool = false
    var availableYears: [String] = Date.now.years(from: 1980).map { "\($0)" }
    var primaryReleaseYear: String = "\(Date.now.component(.year))"
    @Published var year: String = "\(Date.now.component(.year))"
    @Published var moviesList: MovieListResponse?
    @Published var errorMessage: String?
    
    var service: any MovieListServiceProtocol
    
    init(
        service: any MovieListServiceProtocol = MovieListService()
    ) {
        self.service = service
    }
    
    @MainActor
    func fetchMovieList() async {
        moviesList = nil
        do {
            moviesList = try await service.fetchMovieList(of: selectedSection)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
    }
    
    @MainActor
    func search() async {
        moviesList = nil
        do {
            moviesList = try await service.searchMovie(
                query: searchQuery,
                adult: adult,
                language: Locale.current.identifier,
                primaryReleaseYear: primaryReleaseYear,
                region: Locale.current.language.region?.identifier ?? "",
                year: year
            )
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
    }
}
