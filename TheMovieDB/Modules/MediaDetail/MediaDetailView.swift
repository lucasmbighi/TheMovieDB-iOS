//
//  MediaDetailView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import SwiftUI
import SkeletonUI

struct MediaDetailView: View {
    
    @ObservedObject private var viewModel: MediaViewModel
    private let onClose: () -> Void
    
    init(
        viewModel: MediaViewModel,
        onClose: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onClose = onClose
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ImageAsync(
                placeholder: Image("backdrop-w300-placeholder"),
                fetcher: viewModel.fetchBackdropData
            )
            ScrollView {
                Spacer(minLength: 200)
                ZStack(alignment: .top) {
                    VStack {
                        Text("**\(viewModel.mediaTitle)** (\(viewModel.mediaReleaseYear))")
                            .font(.system(size: 18))
                            .padding(20)
                            .frame(maxWidth: .infinity, minHeight: 90, alignment: .center)
                            .padding(20)
                            .padding(.leading, 100)
                        genres
                        overview
                        actorsList
                        crewList
                        Spacer(minLength: 100)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("mediadetail.background"))
                    .cornerRadius(20)
                    .padding(.top, -25)
                    
                    ImageAsync(
                        placeholder: Image("poster-placeholder"),
                        fetcher: { await viewModel.fetchPosterData(size: .w154) }
                    )
                    .cornerRadius(10)
                    .frame(width: 100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, -50)
                    .shadow(radius: 5)
                }
            }
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(10)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
            .padding(.top, 40)
        }
        .background(Color("mediadetail.background"))
        .ignoresSafeArea()
        .task {
            await viewModel.getGenres()
            await viewModel.getCredits()
        }
    }
    
    private func label(of genre: GenreResponse) -> some View {
        Text(genre.name)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            .padding(10)
            .background(Color("mediadetail.genre.foreground"))
            .cornerRadius(40)
    }
    
    private var genres: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.genres) { genre in
                    label(of: genre)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var overview: some View {
        Group {
            Text("mediadetail.storyline".localized)
                .font(.system(size: 18, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            Text(viewModel.mediaOverview)
                .font(.system(size: 16))
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
        }
    }

    private var actorsList: some View {
        Group {
            Text("mediadetail.cast".localized)
                .font(.system(size: 18, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .skeleton(with: viewModel.actorsList.isEmpty)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.actorsList) { cast in
                        VStack {
                            ImageAsync(
                                placeholder: Image("Carrie Fisher"),
                                fetcher: { await viewModel.fetchProfileImageData(of: cast) }
                            )
                            .frame(height: 150)
                            .clipShape(Circle())
                            .padding(.vertical, -20)
                            
                            Text(cast.name)
                                .font(.system(size: 14))
                            Text(cast.character)
                                .font(.system(size: 14, weight: .black))
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var crewList: some View {
        Group {
            Text("mediadetail.crew".localized)
                .font(.system(size: 18, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .skeleton(with: viewModel.crewList.isEmpty)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.crewList) { cast in
                        VStack {
                            Text(cast.name)
                                .font(.system(size: 14))
                            Text(cast.character)
                                .font(.system(size: 14, weight: .black))
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let media = MediaListResponse.fromLocalJSON?.results[1]
        let viewModel = MediaViewModel(
            media: media ?? .empty,
            type: .movie,
            globalMessage: .constant(.init(message: "Message", success: false)
                                    )
        )
        viewModel.genres = GenreListResponse.fromLocalJSON?.genres ?? []
        viewModel.credits = CreditListResponse.fromLocalJSON ?? .empty
        return MediaDetailView(viewModel: viewModel, onClose: { })
        //            .preferredColorScheme(.dark)
    }
}
