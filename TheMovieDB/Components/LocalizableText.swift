//
//  LocalizableText.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/09/23.
//

import SwiftUI

struct LocalizableText: View {
    
    @State private var isLoading: Bool = true
    @State private var text: String
    
    private let key: String
    
    init(_ key: String) {
        self.key = key
        self.text = key
    }
    
    var body: some View {
        Text(text)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray)
                    .isHidden(!isLoading)
            )
            .task {
                translate()
            }
    }
    
    private func translate() {
        let localizedString = NSLocalizedString(key, comment: "")
        print(localizedString)
        if localizedString == key {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                text = "This is the translated text"
            }
        } else {
            text = localizedString
        }
        withAnimation {
            isLoading = false
        }
    }
}

struct LocalizableText_Previews: PreviewProvider {
    static var previews: some View {
        LocalizableText("hello")
            .environment(\.locale, .init(identifier: "pt-BR"))
    }
}
