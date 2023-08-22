//
//  ImageCache.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 21/08/23.
//

import Foundation

protocol CachePluginType {
    var cache: NSCache<NSString, NSData> { get set }
    
    func cachedData(of url: URL) -> Data?
    func set(_ data: Data, for url: URL?)
}

extension CachePluginType {
    func cachedData(of url: URL) -> Data? {
        return cache.object(forKey: url.absoluteString as NSString) as? Data
    }
    
    func set(_ data: Data, for url: URL?) {
        guard let url else { return }
        cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
    }
}

final class ImageCache: CachePluginType {

    static let shared = ImageCache()

    var cache: NSCache<NSString, NSData>
    
    private init() { self.cache = .init() }
}
