//
//  ProfileViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

protocol ProfileViewModelProtocol {
    var service: ProfileService { get set }
    var imageService: ImageService { get set }
    var authenticator: Authenticator { get set }
    var accountDetails: AccountDetailResponse? { get set }
    var avatarData: Data { get set }
    var showLogoutAlert: Bool { get set }
    var isLoading: Bool { get set }
    var favorites: [MediaResponse] { get set }
    var globalMessage: GlobalMessage? { get set }
    
    init(
        service: ProfileService,
        imageService: ImageService,
        authenticator: Authenticator
    )
    
    func getAccountDetails() async
    func fetchAvatarData() async
    func logout() async throws
}

final class ProfileViewModel: ProfileViewModelProtocol, ObservableObject {
    
    var service: ProfileService
    var imageService: ImageService
    var authenticator: Authenticator
    
    @Published var accountDetails: AccountDetailResponse?
    @Published var avatarData: Data = Data.fromAsset(withName: "avatar-w200-placeholder")
    @Published var showLogoutAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var favorites: [MediaResponse] = []
    @Published var globalMessage: GlobalMessage?
    
    init(
        service: ProfileService = .init(),
        imageService: ImageService = .init(),
        authenticator: Authenticator = .shared
    ) {
        self.service = service
        self.imageService = imageService
        self.authenticator = authenticator
    }
    
    @MainActor
    func getAccountDetails() async {
        do {
            accountDetails = try await authenticator.getAccountDetails()
            await fetchAvatarData()
        } catch {
            globalMessage = .init(from: error)
        }
    }
    
    @MainActor
    func fetchAvatarData() async {
        let avatarData = try? await imageService.imageData(ofType: .avatar(.w200), atPath: avatarPath)
        self.avatarData = avatarData ?? Data.fromAsset(withName: "avatar-w200-placeholder")
    }
    
    @MainActor
    func logout() async throws {
        isLoading = true
        try await authenticator.logout()
    }
    
    @MainActor
    func favorite(mediaRequest: SaveMediaRequest) async {
        do {
            let accountId = try await authenticator.getAccountDetails().id
            let response: RequestResponse = try await service.favorite(accountId: accountId, mediaRequest: mediaRequest)
            globalMessage = .init(message: response.statusMessage, success: response.success)
        } catch {
            globalMessage = .init(from: error)
        }
    }
    
    @MainActor
    func addToWatchList(mediaRequest: SaveMediaRequest) async {
        do {
            let accountId = try await authenticator.getAccountDetails().id
            let response: RequestResponse = try await service.addToWatchList(accountId: accountId, mediaRequest: mediaRequest)
            globalMessage = .init(message: response.statusMessage, success: response.success)
        } catch {
            globalMessage = .init(from: error)
        }
    }
    
    @MainActor
    func getFavoriteMovies() async {
        do {
            let accountId = try await authenticator.getAccountDetails().id
            favorites = try await service.getFavoriteMovies(accountId: accountId).results
        } catch {
            globalMessage = .init(from: error)
        }
    }
    
    @MainActor
    func getFavoriteSeries() async {
        do {
            let accountId = try await authenticator.getAccountDetails().id
            favorites = try await service.getFavoriteMovies(accountId: accountId).results
        } catch {
            globalMessage = .init(from: error)
        }
    }
    
    @MainActor
    func getLists() async {
        do {
            let accountId = try await authenticator.getAccountDetails().id
            let response: ListsResponse = try await service.getLists(accountId: accountId)
        } catch {
            globalMessage = .init(from: error)
        }
    }
}

//MARK: Computed properties
extension ProfileViewModel {
    var avatarPath: String { accountDetails?.avatar.tmdb.avatarPath ?? "" }
    var name: String { accountDetails?.name ?? accountDetails?.username ?? "" }
}
