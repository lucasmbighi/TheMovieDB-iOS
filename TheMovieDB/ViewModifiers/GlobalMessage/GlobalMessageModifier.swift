//
//  GlobalMessageModifier.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 06/09/23.
//

import SwiftUI

struct GlobalMessageModifier: ViewModifier {
    
    @Binding var message: GlobalMessage?
    @State private var show: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .zIndex(0)
            if show {
                VStack {
                    HStack {
                        Text(message?.message)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity)
                    .background(background)
                    Spacer()
                }
                .zIndex(1)
                .transition(.move(edge: .top))
                .ignoresSafeArea()
                .task {
                    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                        withAnimation(.easeInOut(duration: 1)) {
                            self.message = nil
                        }
                    }
                }
            }
        }
        .onChange(of: message) { newMessage in
            withAnimation {
                show = newMessage != nil
            }
        }
    }
    
    private var background: Color {
        if let message {
            return message.success ? .green : .red
        }
        return .clear
    }
}

extension View {
    func globalMessage(_ message: Binding<GlobalMessage?>) -> some View {
        modifier(GlobalMessageModifier(message: message))
    }
}

struct GlobalMessageModifier_Preview: PreviewProvider {
    
    struct Preview: View {
        
        @State var errorMessage: GlobalMessage?
        
        var body: some View {
            Button {
                errorMessage = GlobalMessage(message: "Error after 2 seconds", success: false)
            } label: {
                Text("Test error")
            }
            .globalMessage($errorMessage)
        }
    }
    
    static var previews: some View {
        VStack {
            Preview()
        }
    }
}
