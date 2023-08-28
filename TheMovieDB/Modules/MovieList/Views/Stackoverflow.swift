//
//  Stackoverflow.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 28/08/23.
//

import SwiftUI

struct TestRisingView: View {

    let screen = UIScreen.main.bounds

    @State var showingView = false
    @State var selectedModel: Model?
    @State var btFrame: CGRect = .zero
    @State var models: [Model] = (0...3).map { Model(id: $0) }

    var body: some View {
        ZStack {
            VStack {
//                ForEach(models) { model in
//                    activatingButton(model: model, frame: g.frame(in: .global))
//                }
            }

            if let selectedModel {
                topView(model: selectedModel)
                    .zIndex(1)
//                    .transition(
//                        AnyTransition.scale(scale: 0.12).combined(with:
//                        AnyTransition.offset(x: self.btFrame.origin.x - g.size.width/2.0,
//                                             y: self.btFrame.origin.y - g.size.height/2.0))
//                    )
            }
        }
    }

    func activatingButton(model: Model, frame: CGRect) -> some View {
        Button(action: {
            withAnimation {
                self.btFrame = frame
                self.showingView.toggle()
                selectedModel = model
            }
        }) {
            Text("Tap to show model \(model.id)")
                .padding()
                .background(Color.yellow)
        }
        .position(frame.origin)
    }

    func topView(model: Model) -> some View {
        Rectangle()
            .fill(Color.green)
            .overlay(
                VStack {
                    Text("\(model.id)")
                    Button("Close") {
                        withAnimation {
                            self.btFrame = .zero
                            selectedModel = nil
                        }
                    }
                }
            )
            .frame(width: 300, height: 400)
    }
}

struct Model: Identifiable {
    let id: Int
}

struct TestRisingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TestRisingView()
        }
    }
}
