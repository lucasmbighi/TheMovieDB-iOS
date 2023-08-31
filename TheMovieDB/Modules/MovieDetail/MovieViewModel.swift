//
//  HomeListItemViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

protocol MovieViewModelProtocol {
    var movie: MovieResponse { get set }
    var type: HomeListType { get set }
    var movieService: any MovieServiceProtocol { get set }
    var imageService: ImageService { get set }
    var genres: [GenreResponse] { get set }
    var credits: CreditListResponse { get set }
    
    init(
        movie: MovieResponse,
        type: HomeListType,
        movieService: any MovieServiceProtocol,
        imageService: ImageService
    )
    
    func fetchPosterData(size: ImageRequest.ImageType.PosterSize) async -> Data
    func fetchBackdropData() async -> Data
    func getGenres() async
    func getCredits() async
    func fetchProfileImageData(of cast: CastResponse) async -> Data
}

final class MovieViewModel: ObservableObject, MovieViewModelProtocol {
    //MARK: Public properties
    var movie: MovieResponse
    var type: HomeListType
    var movieService: any MovieServiceProtocol
    var imageService: ImageService
    
    //MARK: Published properties
    @Published var genres: [GenreResponse] = []
    @Published var credits: CreditListResponse = .empty
    
    init(
        movie: MovieResponse,
        type: HomeListType,
        movieService: any MovieServiceProtocol = MovieService(),
        imageService: ImageService = .init()
    ) {
        self.movie = movie
        self.type = type
        self.movieService = movieService
        self.imageService = imageService
    }
    
    func fetchPosterData(size: ImageRequest.ImageType.PosterSize) async -> Data {
        let placeholderData = Data.fromAsset(withName: "poster-placeholder")
        if let posterPath = movie.posterPath {
            let posterData = try? await imageService.imageData(ofType: .poster(size), atPath: posterPath)
            return posterData ?? Data.fromAsset(withName: "poster-placeholder")
        }
        return placeholderData
    }
    
    func fetchBackdropData() async -> Data {
        let placeholderData = Data.fromAsset(withName: "poster-placeholder")
        if let backdropPath = movie.backdropPath {
            let backdropData = try? await imageService.imageData(ofType: .backdrop(.w780), atPath: backdropPath)
            return backdropData ?? placeholderData
        }
        return placeholderData
    }
    
    @MainActor
    func getGenres() async {
        let genreList = try? await type == .movie ? movieService.getMovieGenreList() : movieService.getSerieGenreList()
        genres = genreList?.genres.filter { movie.genreIds.contains($0.id) } ?? []
    }
    
    @MainActor
    func getCredits() async {
        let creditList = try? await type == .movie ? movieService.getCredits(ofMovie: movie) : movieService.getCredits(ofSerie: movie)
        credits = creditList ?? .empty
    }
    
    func fetchProfileImageData(of cast: CastResponse) async -> Data {
        let profileData = try? await imageService.imageData(ofType: .profile(.w185), atPath: cast.profilePath ?? "")
        return profileData ?? Data.fromAsset(withName: "")
    }
}

//MARK: Computed properties
extension MovieViewModel {
    var movieTitle: String { movie.title ?? movie.name ?? "" }
    var movieReleaseDate: Date { movie.releaseDate?.toDate() ?? movie.firstAirDate?.toDate() ?? .now }
    var movieReleaseYear: String { movieReleaseDate.formatted(.dateTime.year()) }
    var movieRating: Double { movie.voteAverage / 2 }
    var movieOverview: String { movie.overview }
    var actorsList: [CastResponse] { credits.cast.filter { $0.knownForDepartment == .acting } }
    var crewList: [CastResponse] { credits.cast.filter { $0.knownForDepartment != .acting } }
}
