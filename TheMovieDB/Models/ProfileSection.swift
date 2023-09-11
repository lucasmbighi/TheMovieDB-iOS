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
    
    var title: String {
        switch self {
        case .favoriteMovies: return "Favorite movies"
        case .favoriteSeries: return "Favorite series"
        case .myLists: return "My lists"
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
                Text(title)
            }
        }
    }
}

extension ProfileSection: Identifiable {
    var id: Self { self }
}
