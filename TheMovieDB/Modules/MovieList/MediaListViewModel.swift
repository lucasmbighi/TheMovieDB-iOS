//
//  MediaListViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

protocol MediaListViewModelProtocol {
    var listType: MediaType { get set }
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
    var medias: [MediaResponse] { get set }
    var errorMessage: String? { get set }
    var service: any MediaListServiceProtocol { get set }
    
    init(service: any MediaListServiceProtocol)
    
    @MainActor func fetchList() async
    @MainActor func search() async
    func checkToLoadMoreItems(with media: MediaResponse)
    @MainActor func loadMoreItems() async
}

final class MediaListViewModel: MediaListViewModelProtocol, ObservableObject {
    
    @Published var listType: MediaType = .movie
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
    @Published var medias: [MediaResponse] = []
    @Published var errorMessage: String?
    @Published var selectedMedia: MediaResponse?
    
    var service: any MediaListServiceProtocol
    
    init(
        service: any MediaListServiceProtocol = MediaListService()
    ) {
        self.service = service
    }
    
    @MainActor
    func fetchList() async {
        isLoading = true
        currentPage = 1
        do {
            let mediaListResponse = try await listType == .movie
            ? service.fetchMovieList(of: selectedMovieSection, atPage: currentPage)
            : service.fetchSerieList(of: selectedSerieSection, atPage: currentPage)
            medias = mediaListResponse.results
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
    
    @MainActor
    func search() async {
        isLoading = true
        let request = MediaListSearchRequest(
            query: searchQuery,
            adult: adult,
            primaryReleaseYear: primaryReleaseYear,
            year: year
        )
        do {
            let mediaListResponse = try await service.search(type: listType, request: request)
            medias = mediaListResponse.results
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
    
    func checkToLoadMoreItems(with media: MediaResponse) {
        if let mediaIndex = medias.firstIndex(of: media),
           mediaIndex == (medias.count - 1) {
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
            let mediaListResponse = try await listType == .movie
            ? service.fetchMovieList(of: selectedMovieSection, atPage: currentPage)
            : service.fetchSerieList(of: selectedSerieSection, atPage: currentPage)
            medias.append(contentsOf: mediaListResponse.results)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
        isLoading = false
    }
}
