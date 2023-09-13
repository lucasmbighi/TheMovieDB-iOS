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
            TextField("lists.list_name".localized, text: $viewModel.newListName)
            TextField("lists.list_description".localized, text: $viewModel.newListDescription)
            ButtonView(
                isLoading: $viewModel.isLoading,
                text: "lists.create_list".localized) {
                    Task {
                        await viewModel.createList()
                    }
                }
            Button(role: .cancel, action: dismiss.callAsFunction) {
                Text("lists.cancel".localized)
            }
        }
    }
}

struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .alert("lists.create_list".localized, isPresented: .constant(true)) {
                CreateListView()
            }
    }
}
