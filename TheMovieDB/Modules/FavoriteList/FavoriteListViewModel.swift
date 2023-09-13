//
//  FavoriteListViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 01/09/23.
//

import Foundation

protocol FavoriteListViewModelProtocol {
    
    var favorites: [MediaResponse] { get set }
    var selectedFavorite: MediaResponse? { get set }
    var isLoading: Bool { get set }
    var globalMessage: GlobalMessage? { get set }
    var mediaType: MediaType { get set }
    var service: any ProfileServiceProtocol { get set }
    var authenticator: Authenticator { get set }
    var viewTitle: String { get }
    
    init(
        mediaType: MediaType,
        service: any ProfileServiceProtocol,
        authenticator: Authenticator
    )
    
    func fetchFavorites() async
}

final class FavoriteListViewModel: FavoriteListViewModelProtocol, ObservableObject {
    
    @Published var favorites: [MediaResponse] = []
    @Published var selectedFavorite: MediaResponse?
    @Published var isLoading: Bool = false
    @Published var globalMessage: GlobalMessage?
    
    var mediaType: MediaType
    var service: any ProfileServiceProtocol
    var authenticator: Authenticator
    
    init(
        mediaType: MediaType,
        service: any ProfileServiceProtocol = ProfileService(),
        authenticator: Authenticator = .shared
    ) {
        self.mediaType = mediaType
        self.service = service
        self.authenticator = authenticator
    }
    
    @MainActor
    func fetchFavorites() async {
        isLoading = true
        do {
            let accountId = try await authenticator.getAccountDetails().id
            favorites = try await mediaType == .movie
            ? service.getFavoriteMovies(accountId: accountId).results
            : service.getFavoriteSeries(accountId: accountId).results
        } catch {
            print(error)
        }
        isLoading = false
    }
}

//MARK: Get-only properties
extension FavoriteListViewModel {
    var viewTitle: String { "favorite.title".localized(mediaType.localizedTitle) }
}
