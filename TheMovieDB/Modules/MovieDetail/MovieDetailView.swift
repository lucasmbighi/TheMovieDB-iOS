//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import SwiftUI

struct MovieDetailView: View {
    
    @ObservedObject private var viewModel: MovieViewModel
    private let onClose: () -> Void
    
    init(
        viewModel: MovieViewModel,
        onClose: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onClose = onClose
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ImageAsync(
                    placeholder: Image("backdrop-w300-placeholder"),
                    fetcher: viewModel.fetchBackdropData
                )
                VStack {
                    HStack {
                        ImageAsync(
                            placeholder: Image("poster-placeholder"),
                            fetcher: { await viewModel.fetchPosterData(size: .w154) }
                        )
                        .cornerRadius(10)
                        .frame(width: 100)
                        .padding(.top, -50)
                        
                        Text("**\(viewModel.movieTitle)** (\(viewModel.movieReleaseYear))")
                            .font(.system(size: 18))
                            .padding(20)
                    }
                    genres
                    overview
                    overview
                    overview
                    overview
                    overview
                }
                .frame(maxWidth: .infinity)
                .background(.green)
                .cornerRadius(20)
                .padding(.top, -25)
            }
        }
        .ignoresSafeArea()
    }
    
    var oldBody: some View {
        
        ZStack(alignment: .top) {
            ImageAsync(
                placeholder: Image("backdrop-w300-placeholder"),
                fetcher: viewModel.fetchBackdropData
            )
            .overlay(alignment: .topTrailing, content: {
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding(10)
                }
            })
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer(minLength: 150)
                    ZStack {
                        VStack(alignment: .leading) {
                            Text("**\(viewModel.movieTitle)** (\(viewModel.movieReleaseYear))")
                                .font(.system(size: 18))
                                .frame(width: 200)
                            FiveStarView(rating: Decimal(viewModel.movieRating))
                                .frame(width: 80, height: 15, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(20)
                        .background(Color("moviedetail.background"))
                        .cornerRadius(20)
                        
                        ImageAsync(
                            placeholder: Image("poster-placeholder"),
                            fetcher: { await viewModel.fetchPosterData(size: .w154) }
                        )
                        .frame(width: 100)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom], 20)
                    }
                    
                    genres
                    overview
                    overview
                    overview
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.getMoviesGenres()
        }
        .background(Color("moviedetail.background"))
        .ignoresSafeArea()
    }
    
    private func label(of genre: GenreResponse) -> some View {
        Text(genre.name)
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .padding(12)
            .background(Color("moviedetail.genre.foreground"))
            .cornerRadius(40)
    }
    
    private var genres: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.genres) { genre in
                    label(of: genre)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var overview: some View {
        Group {
            Text("Storyline")
                .font(.system(size: 18, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            Text(viewModel.movieOverview)
                .font(.system(size: 16))
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let movie = MovieListResponse.fromLocalJSON.results[11]
        let viewModel = MovieViewModel(movie: movie)
        viewModel.genres = GenreListResponse.fromLocalJSON.genres
        return MovieDetailView(viewModel: viewModel) {}
        //            .preferredColorScheme(.dark)
    }
}
