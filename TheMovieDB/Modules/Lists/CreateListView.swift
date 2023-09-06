//
//  CreateListView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 05/09/23.
//

import SwiftUI

struct CreateListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel = .init()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            TextField("List name", text: $viewModel.newListName)
            TextField("List description", text: $viewModel.newListDescription)
            ButtonView(
                isLoading: $viewModel.isLoading,
                text: "Create") {
                    Task {
                        await viewModel.createList()
                    }
                }
            Button(role: .cancel, action: dismiss.callAsFunction) {
                Text("Cancel")
            }
        }
    }
}

struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .alert("Create list", isPresented: .constant(true)) {
                CreateListView()
            }
    }
}
