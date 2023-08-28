//
//  MovieListView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import SwiftUI
import SkeletonUI

struct MovieListView: View {
    
    enum FocusedField {
        case search
    }
    
    @ObservedObject private var viewModel: MovieListViewModel
    @FocusState private var focusedField: FocusedField?
    @Namespace private var namespace
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                movieList
                    .navigationTitle("Watch Now")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        Button {
                            withAnimation {
                                viewModel.isSearching.toggle()
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        .onChange(of: viewModel.isSearching) { isSearching in
                            focusedField = viewModel.isSearching ? .search : nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //Force to show animation
                                Task {
                                    await isSearching ? viewModel.search() : viewModel.fetchMovieList()
                                }
                            }
                        }
                    }
                    .safeAreaInset(edge: .top) {
                        safeAreaInset
                    }
            }
            .zIndex(0)
            .task {
                viewModel.searchQuery = ""
                viewModel.isSearching = false
                await viewModel.fetchMovieList()
            }
            
            if let selectedMovie = viewModel.selectedMovie {
                MovieDetailView(
                    viewModel: MovieViewModel(movie: selectedMovie),
                    onClose: {
                        withAnimation(.easeInOut(duration: 1)) {
                            viewModel.selectedMovie = nil
                        }
                    }
                )
                .matchedGeometryEffect(id: selectedMovie.id, in: namespace)
                .zIndex(1)
            }
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
            if viewModel.movies.isEmpty {
                VStack {
                    Spacer()
                    Text("Nothing found 🔎 👀")
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.movies) { movie in
                            let itemViewModel = MovieViewModel(movie: movie)
                            MovieListItemView(
                                viewModel: itemViewModel,
                                isLoading: viewModel.isLoading
                            )
                            .matchedGeometryEffect(id: movie.id, in: namespace)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 1)) {
                                    viewModel.selectedMovie = movie
                                }
                            }
                            .onAppear { viewModel.checkToLoadMoreItems(with: movie) }
                        }
                    }
                }
                .simultaneousGesture(
                    DragGesture().onChanged { _ in focusedField = nil }
                )
            }
        }
    }
    
    private var safeAreaInset: some View {
        Group {
            if viewModel.isSearching {
                VStack {
                    TextField("", text: $viewModel.searchQuery)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .search)
                        .transition(.opacity)
                        .onChange(of: viewModel.searchQuery) { _ in
                            Task {
                                await viewModel.search()
                            }
                        }
                        .onSubmit {
                            Task {
                                await viewModel.search()
                            }
                        }
                        .submitLabel(.search)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ToggleButtonView(
                                isOn: $viewModel.adult,
                                text: "Adult",
                                onColor: .blue,
                                offColor: .gray
                            )
                            .onChange(of: viewModel.adult) { _ in
                                Task {
                                    await viewModel.search()
                                }
                            }
                            
                            DropdownButtonView(
                                placeholder: "Year",
                                selection: $viewModel.year,
                                options: $viewModel.availableYears
                            )
                            .onChange(of: viewModel.year) { _ in
                                Task {
                                    await viewModel.search()
                                }
                            }
                            
                            DropdownButtonView(
                                placeholder: "Primary Release Year",
                                selection: $viewModel.primaryReleaseYear,
                                options: $viewModel.availableYears
                            )
                            .onChange(of: viewModel.primaryReleaseYear) { _ in
                                Task {
                                    await viewModel.search()
                                }
                            }
                        }
                    }
                }
                .padding(10)
            } else {
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
                .transition(.opacity)
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MovieListViewModel()
        
        viewModel.movies = MovieListResponse.fromLocalJSON.results
        
        return VStack {
            MovieListView(viewModel: viewModel)
        }
        .preferredColorScheme(.light)
    }
}
