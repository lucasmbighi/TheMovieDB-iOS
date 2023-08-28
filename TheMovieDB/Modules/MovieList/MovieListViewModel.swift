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
    var isLoading: Bool { get set }
    var searchQuery: String { get set }
    var adult: Bool { get set }
    var availableYears: [String] { get set }
    var primaryReleaseYear: String { get set }
    var year: String { get set }
    
    var currentPage: Int { get set }
    var movies: [MovieResponse] { get set }
    var errorMessage: String? { get set }
    var service: any MovieListServiceProtocol { get set }
    
    init(service: any MovieListServiceProtocol)
    
    func isSelected(_ section: MovieListSection) -> Bool
    @MainActor func fetchMovieList() async
    @MainActor func search() async
    func checkToLoadMoreItems(with movie: MovieResponse)
}

extension MovieListViewModelProtocol {
    var sections: [MovieListSection] { MovieListSection.allCases }
    
    func isSelected(_ section: MovieListSection) -> Bool { selectedSection == section }
}

final class MovieListViewModel: MovieListViewModelProtocol, ObservableObject {
    
    @Published var selectedSection: MovieListSection = .nowPlaying
    @Published var isSearching: Bool = false
    @Published var isLoading: Bool = false
    @Published var searchQuery: String = ""
    @Published var adult: Bool = false
    var availableYears: [String] = Date.now.years(from: 1980).map { "\($0)" }
    var primaryReleaseYear: String = "\(Date.now.component(.year))"
    @Published var year: String = "\(Date.now.component(.year))"
    var currentPage: Int = 1
    @Published var movies: [MovieResponse] = []
    @Published var errorMessage: String?
    
    var service: any MovieListServiceProtocol
    
    init(
        service: any MovieListServiceProtocol = MovieListService()
    ) {
        self.service = service
    }
    
    @MainActor
    func fetchMovieList() async {
        isLoading = true
        do {
            let movieListResponse = try await service.fetchMovieList(of: selectedSection, atPage: currentPage)
            movies.append(contentsOf: movieListResponse.results)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
    
    @MainActor
    func search() async {
        isLoading = true
        do {
            let movieListResponse = try await service.searchMovie(
                query: searchQuery,
                adult: adult,
                language: Locale.current.identifier,
                primaryReleaseYear: primaryReleaseYear,
                region: Locale.current.language.region?.identifier ?? "",
                year: year
            )
            movies = movieListResponse.results
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
    
    func checkToLoadMoreItems(with movie: MovieResponse) {
        if let movieIndex = movies.firstIndex(of: movie),
           movieIndex == (movies.count - 1) {
            Task {
                currentPage += 1
                await fetchMovieList()
            }
        }
    }
}
