//
//  MediaListItemView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import SwiftUI
import SkeletonUI

struct MediaListItemView: View {
    
    @ObservedObject private var viewModel: MediaViewModel
    private let isLoading: Bool
    
    init(
        viewModel: MediaViewModel,
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
                (text(viewModel.mediaTitle, weight: .bold) + text(" \(viewModel.mediaReleaseYear)"))
                    .skeleton(with: isLoading, lines: 1)
                    .frame(height: isLoading ? 24 : nil)
                FiveStarView(rating: Decimal(viewModel.mediaRating))
                    .skeleton(with: isLoading)
                    .frame(width: 80, height: 15, alignment: .leading)
                text(viewModel.mediaOverview, size: 14)
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
                Button {
                    Task {
                        await viewModel.favorite(true)
                    }
                } label: {
                    Text("medialist.favorite".localized)
                }
                
                menuButton("medialist.add_to_list", image: "list.and.film") {
                    viewModel.showListsAlert = true
                }
                menuButton("medialist.watchlist".localized, image: "bookmark", action: { })
                menuButton("medialist.your_rating", image: "star", action: { })
            }
        }
        .overFullScreen(isPresented: $viewModel.showListsAlert, content: {
            AddMediaToListView(viewModel: .init(media: viewModel.media))
        })
        .task {
            await viewModel.getLists()
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
        action: @escaping () -> ()
    ) -> some View {
        Button {
            action()
        } label: {
            Label(title.localized, systemImage: image)
        }
    }
}

struct MediaListItemView_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State var globalMessage: GlobalMessage?
        
        let media1 = MediaListResponse.fromLocalJSON?.results[1] ?? .empty
        let media2 = MediaListResponse.fromLocalJSON?.results[3] ?? .empty
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach([media1, media2]) { media in
                        let viewModel = MediaViewModel(
                            media: media,
                            type: .movie,
                            globalMessage: $globalMessage
                        )
                        MediaListItemView(
                            viewModel: viewModel,
                            isLoading: true
                        )
                    }
                }
            }
            .globalMessage($globalMessage)
        }
    }
    
    static var previews: some View {
        Preview()
            .preferredColorScheme(.light)
    }
}
