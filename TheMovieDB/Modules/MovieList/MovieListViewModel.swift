//
//  HomeListViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

protocol HomeListViewModelProtocol {
    var listType: HomeListType { get set }
    var selectedMovieSection: MovieListSection { get set }
    var selectedSerieSection: SerieListSection { get set }
    var isSearching: Bool { get set }
    var isLoading: Bool { get set }
    var searchQuery: String { get set }
    var adult: Bool { get set }
    var availableYears: [String] { get set }
    var primaryReleaseYear: String? { get set }
    var year: String? { get set }
    
    var currentPage: Int { get set }
    var movies: [MovieResponse] { get set }
    var errorMessage: String? { get set }
    var service: any HomeListServiceProtocol { get set }
    
    init(service: any HomeListServiceProtocol)
    
    @MainActor func fetchList() async
    @MainActor func search() async
    func checkToLoadMoreItems(with movie: MovieResponse)
    @MainActor func loadMoreItems() async
}

final class HomeListViewModel: HomeListViewModelProtocol, ObservableObject {
    
    @Published var listType: HomeListType = .movie
    @Published var selectedMovieSection: MovieListSection = .nowPlaying
    @Published var selectedSerieSection: SerieListSection = .airingToday
    @Published var isSearching: Bool = false
    @Published var isLoading: Bool = false
    @Published var searchQuery: String = ""
    @Published var adult: Bool = false
    var availableYears: [String] = Date.now.years(from: 1980).map { "\($0)" }
    var primaryReleaseYear: String? = nil
    @Published var year: String? = nil
    var currentPage: Int = 1
    @Published var movies: [MovieResponse] = []
    @Published var errorMessage: String?
    @Published var selectedMovie: MovieResponse?
    
    var service: any HomeListServiceProtocol
    
    init(
        service: any HomeListServiceProtocol = HomeListService()
    ) {
        self.service = service
    }
    
    @MainActor
    func fetchList() async {
        isLoading = true
        currentPage = 1
        do {
            let movieListResponse = try await listType == .movie
            ? service.fetchMovieList(of: selectedMovieSection, atPage: currentPage)
            : service.fetchSerieList(of: selectedSerieSection, atPage: currentPage)
            movies = movieListResponse.results
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
    
    @MainActor
    func search() async {
        isLoading = true
        let request = HomeListSearchRequest(
            query: searchQuery,
            adult: adult,
            primaryReleaseYear: primaryReleaseYear,
            year: year
        )
        do {
            let movieListResponse = try await service.search(type: listType, request: request)
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
                await loadMoreItems()
            }
        }
    }
    
    @MainActor
    func loadMoreItems() async {
        isLoading = true
        do {
            let movieListResponse = try await listType == .movie
            ? service.fetchMovieList(of: selectedMovieSection, atPage: currentPage)
            : service.fetchSerieList(of: selectedSerieSection, atPage: currentPage)
            movies.append(contentsOf: movieListResponse.results)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
}
