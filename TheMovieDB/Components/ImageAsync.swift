//
//  ImageAsync.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import SwiftUI

struct ImageAsync: View {
    
    @State private var imageData: Data?
    
    private let width: CGFloat?
    private let placeholder: Image?
    private let fetcher: () async -> Data
    
    init(
        width: CGFloat? = nil,
        placeholder: Image? = nil,
        fetcher: @escaping () async -> Data
    ) {
        self.width = width
        self.placeholder = placeholder
        self.fetcher = fetcher
    }
    
    var body: some View {
        Group {
            if let imageData, let imageFromData = UIImage(data: imageData) {
                treatedImage(Image(uiImage: imageFromData))
            } else if let placeholder {
                treatedImage(placeholder)
            }
        }
        .task {
            imageData = await fetcher()
        }
    }
    
    private func treatedImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width)
    }
}

struct ImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        ImageAsync(
            placeholder: Image("Carrie Fisher"),
            fetcher: { Data.fromAsset(withName: "Carrie Fisher") }
        )
    }
}
