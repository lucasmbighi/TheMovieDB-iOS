//
//  ServiceType.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import Foundation

protocol ServiceType {
    associatedtype Request: RequestType
    var client: APIClient<Request> { get set }
}
