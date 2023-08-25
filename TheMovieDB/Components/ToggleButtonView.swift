//
//  ToggleButtonView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 24/08/23.
//

import SwiftUI

struct ToggleButtonView: View {
    
    @Binding var isOn: Bool
    
    let text: String
    let onColor: Color
    let offColor: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: isOn ? .regular : .light))
            .foregroundColor(.white)
            .padding(10)
            .background(isOn ? onColor : offColor)
            .cornerRadius(20)
            .onTapGesture(perform: toggle)
    }
    
    private func toggle() {
        isOn.toggle()
    }
}

struct ToggleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleButtonView(
            isOn: .constant(false),
            text: "On?",
            onColor: .blue,
            offColor: .gray
        )
    }
}
