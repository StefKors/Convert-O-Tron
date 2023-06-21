//
//  Convert_O_TronApp.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 21/06/2023.
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct Convert_O_TronApp: App {
    @StateObject private var model = Model()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .onDrop(of: [.opml, .fileURL], delegate: DropHandler(isDropping: $model.isDropping, isValidFileType: $model.isValidFileType, callback: model.handleOnDrop))
        }
        .windowResizability(.contentMinSize)

        WindowGroup(id: "debug-window") {
            DebugWindowContentView()
                .environmentObject(model)
                .onDrop(of: [.opml, .fileURL], delegate: DropHandler(isDropping: $model.isDropping, isValidFileType: $model.isValidFileType, callback: model.handleOnDrop))
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
