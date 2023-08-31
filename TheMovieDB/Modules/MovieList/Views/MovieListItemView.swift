//
//  HomeListItemView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import SwiftUI
import SkeletonUI

struct HomeListItemView: View {
    
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
                (text(viewModel.movieTitle, weight: .bold) + text(" \(viewModel.movieReleaseYear)"))
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
        .contextMenu {
            Group {
                menuButton("Add to list", image: "list.and.film", action: { })
                menuButton("Favorite", image: "heart", action: { })
                menuButton("Watchlist", image: "bookmark", action: { })
                menuButton("Your rating", image: "star", action: { })
            }
        }
    }
    
    private func text(_ text: String, weight: Font.Weight? = nil, size: CGFloat = 16) -> Text {
        Text(text)
            .font(.system(size: size, weight: weight))
            .foregroundColor(.white)
    }
    
    private func menuButton(
        _ title: String,
        image: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) { Label(title, systemImage: image) }
    }
}

struct HomeListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let movie1 = HomeListResponse.fromLocalJSON?.results[1] ?? .empty
        let movie2 = HomeListResponse.fromLocalJSON?.results[3] ?? .empty
        
        return ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                HomeListItemView(
                    viewModel: MovieViewModel(movie: movie1, type: .movie), isLoading: true
                )
                HomeListItemView(
                    viewModel: MovieViewModel(movie: movie2, type: .serie), isLoading: false
                )
            }
            .preferredColorScheme(.light)
        }
    }
}
