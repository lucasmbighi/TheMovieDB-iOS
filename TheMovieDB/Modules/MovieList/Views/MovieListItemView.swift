//
//  MovieListItemView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import SwiftUI

struct MovieListItemView: View {
    
    @ObservedObject private var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ImageAsync(
            placeholder: Image("poster-placeholder"),
            fetcher: viewModel.fetchPosterData
        )
        .overlay(alignment: .bottom, content: {
            VStack(alignment: .leading) {
                text(viewModel.movieTitle, weight: .bold) + text(viewModel.movieReleaseYear)
                FiveStarView(rating: Decimal(viewModel.movieRating))
                    .frame(width: 80, height: 15, alignment: .leading)
                text(viewModel.movieOverview, size: 14)
                    .frame(height: 60)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.black.opacity(0.7))
        })
        .cornerRadius(20)
    }
    
    private func text(_ text: String, weight: Font.Weight? = nil, size: CGFloat = 16) -> Text {
        Text(text)
            .font(.system(size: size, weight: weight))
            .foregroundColor(.white)
    }
}

struct MovieListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let movie1 = MovieListResponse.fromLocalJSON.results[1]
        let movie2 = MovieListResponse.fromLocalJSON.results[3]
        
        return ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                MovieListItemView(viewModel: MovieViewModel(movie: movie1))
                MovieListItemView(viewModel: MovieViewModel(movie: movie2))
            }
            .preferredColorScheme(.light)
        }
    }
}
