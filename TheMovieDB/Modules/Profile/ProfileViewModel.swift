//
//  ProfileViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

protocol ProfileViewModelProtocol {
    var service: ProfileService { get set }
    var authService: any AuthServiceProtocol { get set }
    var imageService: ImageService { get set }
    var accountDetails: AccountDetailResponse? { get set }
    var avatarData: Data { get set }
    var errorMessage: String? { get set }
    var showLogoutAlert: Bool { get set }
    var isLoading: Bool { get set }
    
    init(
        service: ProfileService,
        authService: any AuthServiceProtocol,
        imageService: ImageService
    )
    
    @MainActor func getAccountDetails() async
    @MainActor func fetchAvatarData() async
    @MainActor func logout() async throws
}

final class ProfileViewModel: ProfileViewModelProtocol, ObservableObject {
    
    var service: ProfileService
    var authService: any AuthServiceProtocol
    var imageService: ImageService
    
    @Published var accountDetails: AccountDetailResponse?
    @Published var avatarData: Data = Data.fromAsset(withName: "avatar-w200-placeholder")
    @Published var errorMessage: String?
    @Published var showLogoutAlert: Bool = false
    @Published var isLoading: Bool = false
    
    init(
        service: ProfileService = .init(),
        authService: any AuthServiceProtocol = AuthService.shared,
        imageService: ImageService = .init()
    ) {
        self.service = service
        self.authService = authService
        self.imageService = imageService
    }
    
    @MainActor
    func getAccountDetails() async {
        do {
            accountDetails = try await authService.getAccountDetails()
            await fetchAvatarData()
        } catch {
            errorMessage = (error as? NetworkError)?.errorDescription
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
        try await authService.logout()
    }
    
    @MainActor
    func favorite(mediaRequest: SaveMediaRequest) async {
        do {
            let response: RequestResponse = try await service.favorite(mediaRequest: mediaRequest)
            if !response.success {
                errorMessage = response.statusMessage
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func addToWatchList(mediaRequest: SaveMediaRequest) async {
        do {
            let response: RequestResponse = try await service.addToWatchList(mediaRequest: mediaRequest)
            if !response.success {
                errorMessage = response.statusMessage
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getFavoriteMovies() async {
        do {
            let response: RequestResponse = try await service.getFavoriteMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getFavoriteSeries() async {
        do {
            let response: RequestResponse = try await service.getFavoriteMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getLists() async {
        do {
            let response: RequestResponse = try await service.getFavoriteMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

//MARK: Computed properties
extension ProfileViewModel {
    var avatarPath: String { accountDetails?.avatar.tmdb.avatarPath ?? "" }
    var name: String { accountDetails?.name ?? accountDetails?.username ?? "" }
}
