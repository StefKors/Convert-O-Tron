//
//  DropHandler.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI
import UniformTypeIdentifiers

class DropHandler: DropDelegate, ObservableObject {
    @Binding var isDropping: Bool
    @Binding var isValidFileType: Bool
    var callback: (_ url: URL) -> Void

    init(isDropping: Binding<Bool>, isValidFileType: Binding<Bool>, callback: @escaping (_ url: URL) -> Void) {
        self._isDropping = isDropping
        self._isValidFileType = isValidFileType
        self.callback = callback
    }

    // Tells the delegate a validated drop has entered the modified view.
    func dropEntered(info: DropInfo) {
        isDropping = true
        isValidFileType = info.hasItemsConforming(to: [.opml])
    }

    // Tells the delegate a validated drop operation has exited the modified view.
    func dropExited(info: DropInfo) {
        isDropping = false
        isValidFileType = false
    }

    // Tells the delegate that a validated drop moved inside the modified view.
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .copy)
    }

    // Tells the delegate that a drop containing items conforming to one of the expected types entered a view that accepts drops.
    func validateDrop(info: DropInfo) -> Bool {
        isValidFileType = info.hasItemsConforming(to: [.opml])
        return true
    }

    // Tells the delegate it can request the item provider data from the given information.
    func performDrop(info: DropInfo) -> Bool {
        let providers = info.itemProviders(for: [.opml])
        for provider in providers {
            _ = provider.loadFileRepresentation(for: .opml) { url, suceess, error in
                if let error {
                    print(error.localizedDescription)
                    Task {
                        await MainActor.run {
                            self.isValidFileType = false
                        }
                    }
                    return
                }

                if let url {
                    if FileManager.default.fileExists(atPath: url.path) {
                        // Construct new location url
                        let newLocation = FileManager.default.temporaryDirectory.appending(component: url.lastPathComponent)
                        // Overwrite existing file
                        if FileManager.default.fileExists(atPath: newLocation.path) {
                            try? FileManager.default.removeItem(atPath: newLocation.path)
                        }
                        // Move to new location
                        try? FileManager.default.moveItem(at: url, to: newLocation)
                        // Update model with new file
                        Task {
                            await MainActor.run {
                                self.callback(newLocation)
                            }
                        }
                    }
                }
            }
        }

        return info.hasItemsConforming(to: [.opml])
    }
}
