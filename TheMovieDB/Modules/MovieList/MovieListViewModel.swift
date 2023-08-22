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
    var moviesList: MovieListResponse? { get set }
    var errorMessage: String? { get set }
    var service: any MovieListServiceProtocol { get set }
    
    init(service: any MovieListServiceProtocol)
    
    func isSelected(_ section: MovieListSection) -> Bool
    func fetchMovieList() async
}

extension MovieListViewModelProtocol {
    var sections: [MovieListSection] { MovieListSection.allCases }
    
    func isSelected(_ section: MovieListSection) -> Bool { selectedSection == section }
}

final class MovieListViewModel: MovieListViewModelProtocol, ObservableObject {
    
    @Published var selectedSection: MovieListSection = .nowPlaying
    @Published var moviesList: MovieListResponse?
    @Published var errorMessage: String?
    
    var service: any MovieListServiceProtocol
    
    init(service: any MovieListServiceProtocol = MovieListService()) {
        self.service = service
    }
    
    @MainActor
    func fetchMovieList() async {
        do {
            moviesList = try await service.fetchMovieList(of: selectedSection)
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
        }
    }
}
