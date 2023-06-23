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
    @StateObject private var dropWindowModel = Model()
    @StateObject private var debugWindowModel = Model()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dropWindowModel)
                .onDrop(of: [.opml, .fileURL], delegate: DropHandler(isDropping: $dropWindowModel.isDropping, isValidFileType: $dropWindowModel.isValidFileType, callback: dropWindowModel.handleOnDrop))
        }
        .windowResizability(.contentMinSize)

        WindowGroup(id: "debug-window") {
            DebugWindowContentView()
                .environmentObject(debugWindowModel)
                .onDrop(of: [.opml, .fileURL], delegate: DropHandler(isDropping: $debugWindowModel.isDropping, isValidFileType: $debugWindowModel.isValidFileType, callback: debugWindowModel.handleOnDrop))
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
