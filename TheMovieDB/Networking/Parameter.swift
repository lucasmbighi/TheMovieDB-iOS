//
//  Parameter.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 14/08/23.
//

import Foundation

enum Parameter {
    case dict([String: String])
    case encodable(_ encodable: Encodable)
}
