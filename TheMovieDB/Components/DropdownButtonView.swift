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
    @Binding private var selection: Option
    @Binding private var options: [Option]
    
    init(
        placeholder: String? = nil,
        selection: Binding<Option>,
        options: Binding<[Option]>
    ) {
        self.placeholder = placeholder
        self._selection = selection
        self._options = options
    }
    
    var body: some View {
        Menu {
            Picker(selection: $selection, label: EmptyView()) {
                ForEach(options) { option in
                    Text(option.optionTitle)
                        .tag(option)
                }
            }
        } label: {
            HStack {
                if let placeholder {
                    Text("\(placeholder): ") + Text(selection.optionTitle)
                } else {
                    Text(selection.optionTitle)
                }
                Image(systemName: "chevron.down")
            }
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.white)
            .padding(10)
            .background(.blue)
            .cornerRadius(20)
            .frame(height: 60)
        }
    }
}

struct DropdownButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownButtonView(
            selection: .constant("Option 1"),
            options: .constant(["Option 1", "Option 2"])
        )
    }
}
