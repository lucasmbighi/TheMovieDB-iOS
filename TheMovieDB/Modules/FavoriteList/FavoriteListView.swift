//
//  FavoriteListView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 01/09/23.
//

import SwiftUI

struct FavoriteListView: View {
    
    @ObservedObject private var viewModel: FavoriteListViewModel
    @Namespace private var namespace
    
    init(viewModel: FavoriteListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    if viewModel.favorites.isEmpty {
                        VStack {
                            Spacer()
                            Text("Nothing found 🔎 👀")
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.favorites) { media in
                                    let itemViewModel = MediaViewModel(
                                        media: media,
                                        type: viewModel.mediaType,
                                        globalMessage: $viewModel.globalMessage
                                    )
                                    MediaListItemView(
                                        viewModel: itemViewModel,
                                        isLoading: viewModel.isLoading
                                    )
                                    .matchedGeometryEffect(id: media.id, in: namespace)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            viewModel.selectedFavorite = media
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if let selectedFavorite = viewModel.selectedFavorite {
                    MediaDetailView(
                        viewModel: MediaViewModel(
                            media: selectedFavorite,
                            type: viewModel.mediaType,
                            globalMessage: $viewModel.globalMessage
                        ),
                        onClose: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.selectedFavorite = nil
                            }
                        }
                    )
                    .matchedGeometryEffect(id: selectedFavorite.id, in: namespace)
                    .zIndex(1)
                }
            }
            .navigationTitle(viewModel.viewTitle)
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.fetchFavorites()
            }
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FavoriteListView(viewModel: .init(mediaType: .serie))
        }
    }
}
