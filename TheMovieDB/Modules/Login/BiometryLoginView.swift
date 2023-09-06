//
//  BiometryLoginView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 01/09/23.
//

import SwiftUI

struct BiometryLoginView: View {
    
    @ObservedObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel = .init()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Button(viewModel.buttonTitle, action: viewModel.showCredentialLoginView)
                ButtonView(
                    isLoading: $viewModel.isLoading,
                    text: "Login",
                    action: {
                        Task {
                            await viewModel.loginWithBiometry()
                        }
                    }
                )
            }
            .navigationTitle(viewModel.viewTitle)
            .padding()
        }
        .fullScreenCover(isPresented: $viewModel.showCredentialView) {
            CredentialLoginView()
        }
    }
}

struct BiometryLoginView_Previews: PreviewProvider {
    static var previews: some View {
        BiometryLoginView()
    }
}
