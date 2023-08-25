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
    
    init(
        movie: MovieResponse,
        movieService: any MovieServiceProtocol,
        imageService: ImageService
    )
    
    func fetchPosterData() async -> Data
    func fetchBackdropData() async -> Data
    func getMoviesGenres() async
}

final class MovieViewModel: ObservableObject, MovieViewModelProtocol {
    //MARK: Public properties
    var movie: MovieResponse
    var movieService: any MovieServiceProtocol
    var imageService: ImageService
    
    //MARK: Published properties
    @Published var genres: [GenreResponse] = []
    
    init(
        movie: MovieResponse,
        movieService: any MovieServiceProtocol = MovieService(),
        imageService: ImageService = .init()
    ) {
        self.movie = movie
        self.movieService = movieService
        self.imageService = imageService
    }
    
    func fetchPosterData() async -> Data {
        let posterData = try? await imageService.imageData(ofType: .poster(.w185), atPath: movie.posterPath)
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
        let movieGenreList = try? await movieService.getMovieGenreList()
        genres = movieGenreList?.genres.filter { movie.genreIds.contains($0.id) } ?? []
    }
}

extension MovieViewModel {
    var movieTitle: String { movie.title }
    var movieReleaseDate: Date { movie.releaseDate.toDate() ?? .now }
    var movieReleaseYear: String { " (\(movieReleaseDate.formatted(.dateTime.year())))" }
    var movieRating: Double { movie.voteAverage / 2 }
    var movieOverview: String { movie.overview }
}
