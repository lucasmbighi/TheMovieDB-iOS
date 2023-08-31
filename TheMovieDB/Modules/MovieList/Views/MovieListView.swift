//
//  HomeListView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import SwiftUI
import SkeletonUI

struct HomeListView: View {
    
    enum FocusedField {
        case search
    }
    
    @ObservedObject private var viewModel: HomeListViewModel
    @FocusState private var focusedField: FocusedField?
    @Namespace private var namespace
    
    init(viewModel: HomeListViewModel) {
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
                            if viewModel.isSearching {
                                Text("Cancel")
                            } else {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                        .onChange(of: viewModel.isSearching) { isSearching in
                            focusedField = viewModel.isSearching ? .search : nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //Force to show animation
                                Task {
                                    await isSearching ? viewModel.search() : viewModel.fetchList()
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
                await viewModel.fetchList()
            }
            
            if let selectedMovie = viewModel.selectedMovie {
                MovieDetailView(
                    viewModel: MovieViewModel(movie: selectedMovie, type: viewModel.listType),
                    onClose: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.selectedMovie = nil
                        }
                    }
                )
                .matchedGeometryEffect(id: selectedMovie.id, in: namespace)
                .zIndex(1)
            }
        }
    }
    
    private func movieSectionButton(_ section: MovieListSection) -> some View {
        Button {
            viewModel.selectedMovieSection = section
        } label: {
            Text(section.title)
                .bold()
                .foregroundColor(.white)
                .padding(12)
                .background(viewModel.selectedMovieSection == section ? .green : .gray)
                .cornerRadius(40)
        }
        .onChange(of: viewModel.selectedMovieSection) { _ in
            Task {
                await viewModel.fetchList()
            }
        }
    }
    
    private func serieSectionButton(_ section: SerieListSection) -> some View {
        Button {
            viewModel.selectedSerieSection = section
        } label: {
            Text(section.title)
                .bold()
                .foregroundColor(.white)
                .padding(12)
                .background(viewModel.selectedSerieSection == section ? .green : .gray)
                .cornerRadius(40)
        }
        .onChange(of: viewModel.selectedSerieSection) { _ in
            Task {
                await viewModel.fetchList()
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
                            let itemViewModel = MovieViewModel(
                                movie: movie,
                                type: viewModel.listType
                            )
                            HomeListItemView(
                                viewModel: itemViewModel,
                                isLoading: viewModel.isLoading
                            )
                            .matchedGeometryEffect(id: movie.id, in: namespace)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
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
        VStack {
            HStack {
                Picker(selection: $viewModel.listType, label: EmptyView()) {
                    ForEach(HomeListType.allCases) { listType in
                        Text(listType.rawValue)
                            .tag(listType)
                    }
                }
                .onChange(of: viewModel.listType) { _ in
                    Task {
                        await viewModel.fetchList()
                    }
                }
            }
            .pickerStyle(.segmented)
            
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
                        if viewModel.listType == .movie {
                            ForEach(MovieListSection.allCases) { movieSection in
                                movieSectionButton(movieSection)
                            }
                        } else {
                            ForEach(SerieListSection.allCases) { serieSection in
                                serieSectionButton(serieSection)
                            }
                        }
                    }
                    .padding(.leading, 10)
                }
                .transition(.opacity)
            }
        }
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

struct HomeListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeListViewModel()
        
        //        viewModel.movies = HomeListResponse.fromLocalJSON?.results ?? []
        
        return VStack {
            HomeListView(viewModel: viewModel)
        }
        .preferredColorScheme(.light)
    }
}
