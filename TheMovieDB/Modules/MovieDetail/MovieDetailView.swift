//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import SwiftUI

struct MovieDetailView: View {
    
    @ObservedObject private var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ImageAsync(
                placeholder: Image("backdrop-w300-placeholder"),
                fetcher: viewModel.fetchBackdropData
            )
            .overlay(alignment: .bottom, content: {
                Text("Overview")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(10)
            })
            
            Group {
                text(viewModel.movieTitle, weight: .bold) + text(viewModel.movieReleaseYear)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            
            FiveStarView(rating: Decimal(viewModel.movieRating))
                .frame(width: 80, height: 15, alignment: .leading)
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.genres) { genre in
                        label(of: genre)
                    }
                }
                .padding(20)
            }
            Text("Storyline")
                .font(.system(size: 18, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            Text(viewModel.movieOverview)
                .font(.system(size: 16))
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            Spacer()
        }
        .navigationTitle("Movie details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getMoviesGenres()
        }
    }
    
    private func text(
        _ text: String,
        weight: Font.Weight? = nil,
        size: CGFloat = 24
    ) -> Text {
        Text(text)
            .font(.system(size: size, weight: weight))
    }
    
    private func label(of genre: GenreResponse) -> some View {
        Text(genre.name)
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .padding(12)
            .background(Color("moviedetail.genre.foreground"))
            .cornerRadius(40)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let movie = MovieListResponse.fromLocalJSON.results[0]
        let viewModel = MovieViewModel(movie: movie)
        viewModel.genres = GenreListResponse.fromLocalJSON.genres
        return NavigationView {
            MovieDetailView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
