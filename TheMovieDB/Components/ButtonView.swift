//
//  ButtonView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 22/08/23.
//

import SwiftUI

struct ButtonView: View {
    
    @Binding var isLoading: Bool
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            content
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .cornerRadius(10)
        }
    }
    
    private var content: some View {
        Group {
            if isLoading {
                ProgressView()
                    .controlSize(.regular)
                    .tint(.white)
            } else {
                Text(text)
            }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(isLoading: .constant(true), text: "Login", action: {})
    }
}
