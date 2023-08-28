//
//  MovieListItemView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import SwiftUI
import SkeletonUI

struct MovieListItemView: View {
    
    @ObservedObject private var viewModel: MovieViewModel
    private let isLoading: Bool
    
    init(
        viewModel: MovieViewModel,
        isLoading: Bool
    ) {
        self.viewModel = viewModel
        self.isLoading = isLoading
    }
    
    var body: some View {
        ImageAsync(
            placeholder: Image("poster-placeholder"),
            fetcher: { await viewModel.fetchPosterData(size: .w185) }
        )
        .overlay(alignment: .bottom, content: {
            VStack(alignment: .leading) {
                (text(viewModel.movieTitle, weight: .bold) + text(viewModel.movieReleaseYear))
                    .skeleton(with: isLoading, lines: 1)
                    .frame(height: isLoading ? 24 : nil)
                FiveStarView(rating: Decimal(viewModel.movieRating))
                    .skeleton(with: isLoading)
                    .frame(width: 80, height: 15, alignment: .leading)
                text(viewModel.movieOverview, size: 14)
                    .skeleton(with: isLoading, lines: 3)
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
                MovieListItemView(viewModel: MovieViewModel(movie: movie1), isLoading: true)
                MovieListItemView(viewModel: MovieViewModel(movie: movie2), isLoading: false)
            }
            .preferredColorScheme(.light)
        }
    }
}
