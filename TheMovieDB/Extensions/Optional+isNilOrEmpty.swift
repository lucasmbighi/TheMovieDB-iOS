//
//  Optional+isNilOrEmpty.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 06/09/23.
//

import Foundation

extension Optional where Wrapped: Collection, Wrapped: StringProtocol {
    var isNilOrEmpty: Bool { self?.isEmpty ?? true }
}
