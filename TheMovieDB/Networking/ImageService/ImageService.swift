//
//  ImageService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

final class ImageService: ServiceType {
    
    typealias Request = ImageRequest
    
    var client: APIClient<ImageRequest>
    
    init(client: APIClient<ImageRequest> = .init(cachePlugin: ImageCache.shared)) {
        self.client = client
    }
    
    func imageData(ofType type: ImageRequest.ImageType, atPath path: String) async throws -> Data {
        return try await client.data(from: ImageRequest(type: type, path: path))
    }
}
