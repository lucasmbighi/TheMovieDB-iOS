//
//  MovieListView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import SwiftUI

struct MovieListView: View {
    
    enum FocusedField {
        case search
    }
    
    @ObservedObject private var viewModel: MovieListViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
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
        .task {
            viewModel.searchQuery = ""
            viewModel.isSearching = false
            await viewModel.fetchMovieList()
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
                if movies.isEmpty {
                    VStack {
                        Spacer()
                        Text("Nothing found 🔎 👀")
                        Spacer()
                    }
                } else {
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
                    .simultaneousGesture(
                        DragGesture().onChanged { _ in focusedField = nil }
                    )
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(0..<6, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.gray)
                                .frame(minHeight: 287.016)
                        }
                    }
                }
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
        
        viewModel.moviesList = MovieListResponse.fromLocalJSON
        
        return MovieListView(viewModel: viewModel)
            .preferredColorScheme(.light)
    }
}
