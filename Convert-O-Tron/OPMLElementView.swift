//
//  OPMLElementView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

struct OPMLElementView: View {
    let element: OPMLElement
    @State private var isPresented: Bool = false

    @Environment(\.isFocused) private var isFocussed
    var body: some View {
        if let text = element.attributes[.text] {
            HStack {
                Text(text)
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    Label("Show Details", systemImage: "info.circle")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
                .popover(isPresented: $isPresented, arrowEdge: .bottom, content: {
                    DetailElementView(element: element)
                })
            }
        } else {
            Text(element.name.rawValue.capitalized)
                .bold()
        }
    }
}

struct OPMLElementView_Previews: PreviewProvider {
    static var previews: some View {
        List(OPMLElement.previewChildren, children: \.children) { element in
            OPMLElementView(element: element)
        }
        .scenePadding()
    }
}
