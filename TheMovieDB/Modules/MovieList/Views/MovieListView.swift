//
//  MovieListView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import SwiftUI

struct MovieListView: View {
    
    @ObservedObject private var viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            movieList
            .navigationTitle("Watch Now")
            .safeAreaInset(edge: .top) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.sections) { section in
                            sectionButton(section)
                        }
                    }
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [
                                Color("movielist.section.background").opacity(0.66),
                                Color("movielist.section.background").opacity(0.33),
                                .clear],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                }
            }
        }
        .task {
//            await viewModel.fetchMovieList()
        }
    }
    
    private func sectionButton(_ section: MovieListSection) -> some View {
        Button {
            viewModel.selectedSection = section
        } label: {
            Text(section.title)
                .bold()
                .foregroundColor(.white)
                .padding(12)
                .background(viewModel.isSelected(section) ? .green : .gray)
                .cornerRadius(40)
        }
        .onChange(of: viewModel.selectedSection) { _ in
            Task {
                await viewModel.fetchMovieList()
            }
        }
    }
    
    private var movieList: some View {
        Group {
            if let movies = viewModel.moviesList?.results {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(movies) { movie in
                            let viewModel = MovieViewModel(movie: movie)
                            NavigationLink(destination: MovieDetailView(viewModel: viewModel)) {
                                MovieListItemView(viewModel: viewModel)
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("Nothing to see")
                    Spacer()
                }
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MovieListViewModel()
        
//        viewModel.moviesList = MovieListResponse.fromLocalJSON
        
        return MovieListView(viewModel: viewModel)
            .preferredColorScheme(.light)
    }
}
