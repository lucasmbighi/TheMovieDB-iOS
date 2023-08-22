//
//  AuthPlugin.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 15/08/23.
//

import Foundation

protocol AuthPluginType {
    func prepare(for request: URLRequest) async -> URLRequest
}
