//
//  MediaListItemViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

protocol MediaViewModelProtocol {
    var media: MediaResponse { get set }
    var type: MediaType { get set }
    var mediaService: any MediaServiceProtocol { get set }
    var profileService: any ProfileServiceProtocol { get set }
    var imageService: ImageService { get set }
    var genres: [GenreResponse] { get set }
    var credits: CreditListResponse { get set }
    
    init(
        media: MediaResponse,
        type: MediaType,
        mediaService: any MediaServiceProtocol,
        profileService: any ProfileServiceProtocol,
        imageService: ImageService
    )
    
    func fetchPosterData(size: ImageRequest.ImageType.PosterSize) async -> Data
    func fetchBackdropData() async -> Data
    func getGenres() async
    func getCredits() async
    func fetchProfileImageData(of cast: CastResponse) async -> Data
    func favorite(_ favorite: Bool) async
}

final class MediaViewModel: ObservableObject, MediaViewModelProtocol {
    //MARK: Public properties
    var media: MediaResponse
    var type: MediaType
    var mediaService: any MediaServiceProtocol
    var profileService: any ProfileServiceProtocol
    var imageService: ImageService
    
    //MARK: Published properties
    @Published var genres: [GenreResponse] = []
    @Published var credits: CreditListResponse = .empty
    
    init(
        media: MediaResponse,
        type: MediaType,
        mediaService: any MediaServiceProtocol = MediaService(),
        profileService: any ProfileServiceProtocol = ProfileService(),
        imageService: ImageService = .init()
    ) {
        self.media = media
        self.type = type
        self.mediaService = mediaService
        self.profileService = profileService
        self.imageService = imageService
    }
    
    func fetchPosterData(size: ImageRequest.ImageType.PosterSize) async -> Data {
        let placeholderData = Data.fromAsset(withName: "poster-placeholder")
        if let posterPath = media.posterPath {
            let posterData = try? await imageService.imageData(ofType: .poster(size), atPath: posterPath)
            return posterData ?? Data.fromAsset(withName: "poster-placeholder")
        }
        return placeholderData
    }
    
    func fetchBackdropData() async -> Data {
        let placeholderData = Data.fromAsset(withName: "poster-placeholder")
        if let backdropPath = media.backdropPath {
            let backdropData = try? await imageService.imageData(ofType: .backdrop(.w780), atPath: backdropPath)
            return backdropData ?? placeholderData
        }
        return placeholderData
    }
    
    @MainActor
    func getGenres() async {
        let genreList = try? await type == .movie ? mediaService.getMovieGenreList() : mediaService.getSerieGenreList()
        genres = genreList?.genres.filter { media.genreIds.contains($0.id) } ?? []
    }
    
    @MainActor
    func getCredits() async {
        let creditList = try? await type == .movie ? mediaService.getCredits(ofMovie: media) : mediaService.getCredits(ofSerie: media)
        credits = creditList ?? .empty
    }
    
    func fetchProfileImageData(of cast: CastResponse) async -> Data {
        let profileData = try? await imageService.imageData(ofType: .profile(.w185), atPath: cast.profilePath ?? "")
        return profileData ?? Data.fromAsset(withName: "")
    }
    
    func favorite(_ favorite: Bool) async {
        let mediaRequest = SaveMediaRequest(mediaId: media.id, mediaType: type, favorite: favorite)
        do {
            let response: RequestResponse = try await profileService.favorite(mediaRequest: mediaRequest)
            if !response.success {
//                errorMessage = response.statusMessage
            }
        } catch {
//            errorMessage = error.localizedDescription
        }
    }
}

//MARK: Computed properties
extension MediaViewModel {
    var mediaTitle: String { media.title ?? media.name ?? "" }
    var mediaReleaseDate: Date { media.releaseDate?.toDate() ?? media.firstAirDate?.toDate() ?? .now }
    var mediaReleaseYear: String { mediaReleaseDate.formatted(.dateTime.year()) }
    var mediaRating: Double { media.voteAverage / 2 }
    var mediaOverview: String { media.overview }
    var actorsList: [CastResponse] { credits.cast.filter { $0.knownForDepartment == .acting } }
    var crewList: [CastResponse] { credits.cast.filter { $0.knownForDepartment != .acting } }
}
