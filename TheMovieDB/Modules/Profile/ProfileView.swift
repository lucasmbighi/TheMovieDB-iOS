//
//  ProfileView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Hello, World!")
            .task {
                await viewModel.getAccountDetails()
            }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: .init())
    }
}
