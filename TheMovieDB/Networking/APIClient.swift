//
//  NetworkService.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 11/08/23.
//

import Foundation

typealias CachePolicy = URLRequest.CachePolicy

final class APIClient<Request: RequestType> {
    
    private let session: URLSession
    private var authPlugin: AuthPluginType?
    private var cachePlugin: CachePluginType?
    
    init(
        authPlugin: AuthPluginType? = nil,
        cachePlugin: CachePluginType? = nil
    ) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
        
        self.authPlugin = authPlugin
        self.cachePlugin = cachePlugin
    }
    
    private func retrieve(from request: Request) async throws -> Data {
        guard let url = request.url else {
            throw NetworkError.malformatedURL
        }
        
        var urlRequest = URLRequest(url: url)
        
        switch request.method {
        case .post, .put:
            if case let .dict(dictionary) = request.parameters {
                let httpBodyData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
                urlRequest.httpBody = httpBodyData
            } else if case let .encodable(object) = request.parameters {
                let httpBodyData = try? request.encoder.encode(object)
                urlRequest.httpBody = httpBodyData
            } else if case let .both(_, body) = request.parameters {
                let httpBodyData = try? request.encoder.encode(body)
                urlRequest.httpBody = httpBodyData
            }
        default:
            break
        }
        
        urlRequest.allHTTPHeaderFields = request.headers.reduce(into: [String: String](), { $0[$1.name] = $1.value} )
        urlRequest.httpMethod = request.method.rawValue
        
        if let authPlugin {
            let authenticatedRequest = await authPlugin.prepare(for: urlRequest)
            urlRequest = authenticatedRequest
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        #if DEBUG
        print(response)
        print(String(data: data, encoding: .utf8) ?? "")
        #endif
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        return data
    }
    
    func stubRequest<Model: Decodable>(_ request: Request) async -> Model? {
        return Model.fromLocalJSON
    }
}

extension APIClient {
    func request<Model: Decodable>(_ request: Request) async throws -> Model {
        let data = try await retrieve(from: request)
        do {
            let responseObject = try request.decoder.decode(Model.self, from: data)
            return responseObject
        } catch {
            print(error)
            throw NetworkError.decodeError
        }
    }
    
    func data(from request: Request) async throws -> Data {
        if let cachePlugin, let requestURL = request.url, let cachedData = cachePlugin.cachedData(of: requestURL) {
            return cachedData
        }
        let retrievedData = try await retrieve(from: request)
        cachePlugin?.set(retrievedData, for: request.url)
        return retrievedData
    }
}
