//
//  DetailElementAttributesView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

fileprivate struct TableItem: Identifiable {
    let key: OPMLElement.Attribute
    let value: String
    let id = UUID()
}

struct DetailElementAttributesView: View {
    let attributes: [OPMLElement.Attribute: String]
    
    fileprivate var tableAttributes: [TableItem] {
        attributes.map { (key, value) in
            TableItem(key: key, value: value)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Attributes")
                .bold()
            
            Table(tableAttributes) {
                TableColumn("Attribute", value: \.key.rawValue)
                    .width(min: 20, ideal: 55, max: 55)
                TableColumn("Value", value: \.value)
            }
            .tableStyle(.bordered)
            .frame(minWidth: 200, minHeight: 100, alignment: .center)
        }
    }
}

struct DetailElementAttributesView_Previews: PreviewProvider {
    static var previews: some View {
        DetailElementAttributesView(attributes: OPMLElement.previewLink.attributes)
            .scenePadding()
    }
}
