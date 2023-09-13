//
//  ProfileSection.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 01/09/23.
//

import Foundation
import SwiftUI

enum ProfileSection: CaseIterable {
    case favoriteMovies, favoriteSeries, myLists
    
    var localizedTitle: String {
        switch self {
        case .favoriteMovies:
            return "profile.favorite_movies".localized
        case .favoriteSeries:
            return "profile.favorite_series".localized
        case .myLists:
            return "profile.my_lists".localized
        }
    }
    
    var destination: some View {
        Group {
            switch self {
            case .favoriteMovies:
                FavoriteListView(viewModel: .init(mediaType: .movie))
            case .favoriteSeries:
                FavoriteListView(viewModel: .init(mediaType: .serie))
            case .myLists:
                Text(localizedTitle)
            }
        }
    }
}

extension ProfileSection: Identifiable {
    var id: Self { self }
}
