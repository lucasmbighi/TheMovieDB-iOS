//
//  HiddenModifier.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 23/08/23.
//

import SwiftUI

struct HiddenModifier: ViewModifier {
    
    let isHidden: Bool
    
    func body(content: Content) -> some View {
        if !isHidden {
            content
        }
    }
}

extension View {
    func isHidden(_ isHidden: Bool) -> some View {
        modifier(HiddenModifier(isHidden: isHidden))
    }
}
