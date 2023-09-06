//
//  CredentialLoginView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import SwiftUI

struct CredentialLoginView: View {
    
    enum FocusedField {
        case username, password
    }
    
    @ObservedObject private var viewModel: LoginViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(viewModel: LoginViewModel = .init()) {
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
                    text: "Login",
                    action: {
                        Task {
                            await viewModel.login()
                        }
                    }
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
                focusedField = .username
            }
        }
    }
}

struct CredentialLoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LoginViewModel()
        
//        viewModel.isLoading = false
//        viewModel.errorMessage = "Erro ao carregar objeto"
        
        return CredentialLoginView(viewModel: viewModel)
    }
}
