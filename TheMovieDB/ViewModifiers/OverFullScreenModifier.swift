//
//  OverFullScreenModifier.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 05/09/23.
//

import SwiftUI

struct OverFullScreenModifier<FullScreenContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let fullScreenContent: () -> FullScreenContent
    
    func body(content: Content) -> some View {
        content.fullScreenCover(isPresented: $isPresented) {
            ZStack {
                Color.clear.background(.ultraThinMaterial.opacity(0.1)).ignoresSafeArea()
                fullScreenContent()
            }
            .background(BackgroundBlurView())
            .ignoresSafeArea()
        }
    }
}

extension View {
    func overFullScreen(isPresented: Binding<Bool>, content: @escaping () -> some View) -> some View {
        modifier(OverFullScreenModifier(isPresented: isPresented, fullScreenContent: content))
    }
}

struct OverFullScreenModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
            .background(.blue)
            .overFullScreen(isPresented: .constant(true)) {
                Text("I am the over full screen text")
            }
    }
}
