//
//  ContentView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: Model
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        HStack {
            GroupBox {
                Text(".opml")
            }

            Image(systemName: "arrow.right")

            VStack {
                Image("AppIcon-1024")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Text("Convert-O-Tron")
                    .foregroundStyle(.secondary)
            }
            .padding(40)
            .frame(width: 200, height: 200, alignment: .center)
            .dropzone()

            Image(systemName: "arrow.right")

            GroupBox {
                Text("Ulysses")
            }
        }
        .frame(width: 600, height: 300, alignment: .center)
        .navigationSubtitle("Drop .opml files to import into Ulysses")
        .toolbar(content: {
            ToolbarItem {
                Button("Open Debug Window") {
                    openWindow(id: "debug-window")
                }
            }
        })
        .overlay {
            DragAndDropView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Model())
    }
}
