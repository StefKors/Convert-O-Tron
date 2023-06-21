//
//  DetailElementView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 21/06/2023.
//

import SwiftUI

struct DetailElementView: View {
    let element: OPMLElement
    
    var body: some View {
        VStack(alignment: .leading) {
            if let text = element.attributes[.text] {
                Text(text)
                    .font(.largeTitle)
                    .bold()
            }
            Text("<\(element.name.rawValue)>")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            Divider()
            
            DetailElementAttributesView(attributes: element.attributes)
            
            Divider()
            
            DetailElementChildrenView(children: element.children)
        }
        .padding()
        .frame(minWidth: 200, idealWidth: 300, maxWidth: 500)
    }
    
}

struct DetailElementView_Previews: PreviewProvider {
    static var previews: some View {
        DetailElementView(element: .previewWithChildren)
            .scenePadding()
    }
}
