//
//  ListSectionProtocol.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 31/08/23.
//

import Foundation

protocol ListSectionProtocol: RawRepresentable, CaseIterable, Identifiable, Equatable {
    var localizedTitle: String { get }
}

extension ListSectionProtocol where Self.RawValue == String {
    var localizedTitle: String { rawValue.localized }
}

extension ListSectionProtocol {
    var id: Self { self }
}
