//
//  APIClient+RequestWithDefaulDecoder.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 30/08/23.
//

import Foundation

extension APIClient {
    func request<Model: Decodable>(_ request: Request, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) async throws -> Model {
        return try await self.request(request, decoder: JSONDecoder(keyDecodingStrategy: keyDecodingStrategy))
    }
}
