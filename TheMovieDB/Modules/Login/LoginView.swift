//
//  LoginView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import SwiftUI

struct LoginView: View {
    
    enum FocusedField {
        case username, password
    }
    
    @ObservedObject private var viewModel: LoginViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .username)
                    .disabled(viewModel.isLoading)
                
                SecureField("password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .password)
                    .disabled(viewModel.isLoading)
                Spacer()
                ButtonView(
                    isLoading: $viewModel.isLoading,
                    action: {
                        Task {
                            await viewModel.login()
                        }
                    },
                    text: "Login"
                )
                .disabled(viewModel.username.isEmpty || viewModel.password.isEmpty)
            }
            .padding()
            .sheet(item: $viewModel.errorMessage) { errorMessage in
                Text(errorMessage)
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            }
            .navigationTitle("Login")
            .task {
                if viewModel.hasBiometry {
                    await viewModel.loginWithBiometry()
                } else {
                    focusedField = .username
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LoginViewModel()
        
//        viewModel.isLoading = false
//        viewModel.errorMessage = "Erro ao carregar objeto"
        
        return LoginView(viewModel: viewModel)
    }
}
