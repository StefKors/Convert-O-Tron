//
//  DebugWindowContentView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 21/06/2023.
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers



struct DebugWindowContentView: View {
    @EnvironmentObject private var model: Model
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility, sidebar: {
            List(model.documents, id: \.self, selection: $model.selectedDocument) { item in
                Label(title: {
                    Text(item.lastPathComponent)
                }, icon: {
                    FileIcon(type: UTType(item.pathExtension))
                })
                .contextMenu(menuItems: {
                    Button("Copy Full URL") {
                        copyToPasteboard(item)
                    }
                })
            }
        }, detail: {
            OPMLContentView()
                .overlay {
                    DragAndDropView()
                }
        })
    }

    private func copyToPasteboard(_ url: URL) {
        let content = url.absoluteString
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        pasteboard.setString(content, forType: .rtf)
        pasteboard.setString(content, forType: .URL)
        pasteboard.setString(content, forType: .fileURL)
    }
}

struct DebugWindowContentView_Previews: PreviewProvider {
    static var previews: some View {
        DebugWindowContentView()
            .environmentObject(Model())
    }
}
