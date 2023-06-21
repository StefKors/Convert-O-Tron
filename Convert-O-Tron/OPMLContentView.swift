//
//  MainContentView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 21/06/2023.
//

import SwiftUI

extension ToolbarItemPlacement {
    static let breadcrumbBar = accessoryBar(id: "com.stefkors.breadcrumbBar")
}

struct OPMLContentView: View {
    @EnvironmentObject private var model: Model
    @State private var breadcrumbElement: OPMLElement? = nil

    var body: some View {
        VStack {
            if let body = model.document?.body?.children {
                List(body, children: \.children, selection: $model.selectedElement) { item in
                    OPMLElementView(element: item)
                }
            }
        }
        .toolbar {
            ToolbarItem(id: "breadcrumbBar", placement: .breadcrumbBar) {
                if let breadcrumbElement {
                    ElementBreadcrumbView(breadcrumb: breadcrumbElement.breadcrumb)
                }
            }
        }
        .navigationSubtitle(model.selectedDocument?.lastPathComponent ?? "")
        .task(id: model.selectedElement) {
            guard let id = model.selectedElement else { return }
            self.breadcrumbElement = model.document?.body?.findInChildren(id: id)
        }
        .task(id: model.selectedDocument) {
            guard let url = model.selectedDocument else { return }
            model.document = OPMLParser().parse(url: url)
            // set default selection
            model.selectedElement = model.document?.body?.children?.first?.id
        }
    }
}

struct OPMLContentView_Previews: PreviewProvider {
    static var previews: some View {
        OPMLContentView()
            .scenePadding()
    }
}
