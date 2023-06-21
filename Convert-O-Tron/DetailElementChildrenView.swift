//
//  DetailElementChildrenView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

struct DetailElementChildrenView: View {
    let children: [OPMLElement]?
    var body: some View {
        VStack(alignment: .leading) {
            Text("Children")
                .bold()
                .padding(.bottom, 2)
            
            if let children {
                Grid(alignment: .leading) {
                    ForEach(children) { item in
                        GridRow(alignment: .center) {
                            if let text = item.attributes[.text] {
                                Text(text)
                            }
                            
                            Text("<\(item.name.rawValue)>")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } else {
                Text("no children...")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct DetailElementChildrenView_Previews: PreviewProvider {
    static var previews: some View {
        DetailElementChildrenView(children: OPMLElement.previewChildren)
            .scenePadding()
    }
}
