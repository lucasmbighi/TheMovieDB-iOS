//
//  DropdownButtonView.swift
//  TheMovieDB
//
//  Created by Lucas Bighi on 25/08/23.
//

import SwiftUI

protocol DropdownItemProtocol: Identifiable, Hashable {
    var optionTitle: String { get }
}

struct DropdownButtonView<Option: DropdownItemProtocol>: View {
    
    private let placeholder: String?
    @Binding private var selection: Option?
    @Binding private var options: [Option]
    
    init(
        placeholder: String? = nil,
        selection: Binding<Option?>,
        options: Binding<[Option]>
    ) {
        self.placeholder = placeholder
        self._selection = selection
        self._options = options
    }
    
    var body: some View {
        Menu {
            Picker(selection: $selection, label: EmptyView()) {
                Text("").tag(nil as Option?)
                ForEach(options) { option in
                    Text(option.optionTitle).tag(option as Option?)
                }
            }
        } label: {
            HStack {
                if let placeholder {
                    Text("\(placeholder): ") + Text(selection?.optionTitle ?? "")
                } else {
                    Text(selection?.optionTitle ?? "")
                }
                Image(systemName: "chevron.down")
            }
            .font(.system(size: 18, weight: isNil ? .light : .regular))
            .foregroundColor(.white)
            .padding(10)
            .background(isNil ? .gray : .blue)
            .cornerRadius(20)
        }
    }
    
    private var isNil: Bool { selection == nil }
}

struct DropdownButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownButtonView(
            placeholder: "Year",
            selection: .constant(nil),
            options: .constant(["Option 1", "Option 2"])
        )
    }
}
