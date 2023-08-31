//
//  ListSectionProtocol.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

protocol ListSectionProtocol: RawRepresentable, CaseIterable, Identifiable, Equatable {
    var title: String { get }
}

extension ListSectionProtocol where Self.RawValue == String {
    var title: String { rawValue }
}

extension ListSectionProtocol {
    var id: Self { self }
}
