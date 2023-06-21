//
//  ElementBreadcrumbView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

struct ElementBreadcrumbView: View {
    let breadcrumb: [String]
    var body: some View {
        HStack(alignment: .center, spacing: 2, content: {
            ForEach(breadcrumb, id: \.self) { crumb in
                Button(action: {
                    // noop
                }, label: {
                    Text(crumb)
                })

                if breadcrumb.last != crumb {
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .foregroundStyle(.secondary)
                }
            }
        })
    }
}

struct ElementBreadcrumbView_Previews: PreviewProvider {
    static var previews: some View {
        ElementBreadcrumbView(breadcrumb: ["body", "outline", "outline"])
            .scenePadding()
    }
}
