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
        NavigationStack {
            VStack {
                Image(
                    uiImage: UIImage(data: viewModel.avatarData)
                    ?? UIImage(named: "avatar-w200-placeholder")
                    ?? UIImage()
                )
                .padding(50)
                .background(.blue.opacity(0.4))
                .clipShape(Circle())
                .padding(.horizontal, 60)
                Text(viewModel.name)
                    .font(.system(size: 20, weight: .medium))
                
                List(ProfileSection.allCases) { section in
                    NavigationLink(section.title, destination: section.destination)
                }
                .listStyle(.plain)
                
                ButtonView(
                    isLoading: $viewModel.isLoading,
                    text: "Logout",
                    action: {
                        viewModel.showLogoutAlert = true
                    }
                )
                .padding(20)
            }
            .navigationTitle("Profile")
        }
        .sheet(item: $viewModel.errorMessage) { errorMessage in
            Text(errorMessage)
            Button("OK") {
                viewModel.errorMessage = nil
            }
        }
        .alert(
            "Exit from your account?",
            isPresented: $viewModel.showLogoutAlert,
            actions: {
                Button("Yes") {
                    Task {
                        try await viewModel.logout()
                    }
                }
                Button("Cancel") {
                    viewModel.showLogoutAlert = false
                }
            })
        .task {
            await viewModel.getAccountDetails()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ProfileViewModel()
        viewModel.accountDetails = AccountDetailResponse.fromLocalJSON
        return ProfileView(viewModel: viewModel)
    }
}
