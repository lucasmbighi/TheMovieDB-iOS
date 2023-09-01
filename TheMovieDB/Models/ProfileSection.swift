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
        switch self {
        case .favoriteMovies:
            return Text(title)
        case .favoriteSeries:
            return Text(title)
        case .myLists:
            return Text(title)
        }
    }
}

extension ProfileSection: Identifiable {
    var id: Self { self }
}
