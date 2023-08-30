//
//  MovieListItemViewModel.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

protocol MovieViewModelProtocol {
    var movie: MovieResponse { get set }
    var movieService: any MovieServiceProtocol { get set }
    var imageService: ImageService { get set }
    var genres: [GenreResponse] { get set }
    var credits: CreditListResponse { get set }
    
    init(
        movie: MovieResponse,
        movieService: any MovieServiceProtocol,
        imageService: ImageService
    )
    
    func fetchPosterData(size: ImageRequest.ImageType.PosterSize) async -> Data
    func fetchBackdropData() async -> Data
    func getMoviesGenres() async
    func getCredits() async
    func fetchProfileImageData(of cast: CastResponse) async -> Data
}

final class MovieViewModel: ObservableObject, MovieViewModelProtocol {
    //MARK: Public properties
    var movie: MovieResponse
    var movieService: any MovieServiceProtocol
    var imageService: ImageService
    
    //MARK: Published properties
    @Published var genres: [GenreResponse] = []
    @Published var credits: CreditListResponse = .empty
    
    init(
        movie: MovieResponse,
        movieService: any MovieServiceProtocol = MovieService(),
        imageService: ImageService = .init()
    ) {
        self.movie = movie
        self.movieService = movieService
        self.imageService = imageService
    }
    
    func fetchPosterData(size: ImageRequest.ImageType.PosterSize) async -> Data {
        let posterData = try? await imageService.imageData(ofType: .poster(size), atPath: movie.posterPath)
        return posterData ?? Data.fromAsset(withName: "poster-placeholder")
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
    func getMoviesGenres() async {
        let genreList = try? await movieService.getMovieGenreList()
        genres = genreList?.genres.filter { movie.genreIds.contains($0.id) } ?? []
    }
    
    @MainActor
    func getCredits() async {
        let creditList = try? await movieService.getCredits(ofMovie: movie)
        credits = creditList ?? .empty
    }
    
    func fetchProfileImageData(of cast: CastResponse) async -> Data {
        let profileData = try? await imageService.imageData(ofType: .profile(.w185), atPath: cast.profilePath ?? "")
        return profileData ?? Data.fromAsset(withName: "")
    }
}

//MARK: Computed properties
extension MovieViewModel {
    var movieTitle: String { movie.title }
    var movieReleaseDate: Date { movie.releaseDate.toDate() ?? .now }
    var movieReleaseYear: String { movieReleaseDate.formatted(.dateTime.year()) }
    var movieRating: Double { movie.voteAverage / 2 }
    var movieOverview: String { movie.overview }
    var actorsList: [CastResponse] { credits.cast.filter { $0.knownForDepartment == .acting } }
    var crewList: [CastResponse] { credits.cast.filter { $0.knownForDepartment != .acting } }
}
