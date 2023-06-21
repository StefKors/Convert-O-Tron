//
//  Model.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

class Model: ObservableObject {
    @Published var documents: [URL] = [
        Bundle.main.url(forResource: "states", withExtension: "opml")!,
        Bundle.main.url(forResource: "placesLived", withExtension: "opml")!,
        Bundle.main.url(forResource: "directory", withExtension: "opml")!,
        Bundle.main.url(forResource: "simpleScript", withExtension: "opml")!
    ]
    @Published var selectedDocument: URL?
    @Published var selectedElement: OPMLElement.ID?
    @Published var document: OPMLDocument?

    @Published var isDropping: Bool = false
    @Published var isValidFileType: Bool = false

    init() {
        // Set default document selection
        self.selectedDocument = documents.first
    }

    func handleOnDrop(_ newLocation: URL) {
        addDocumentToModel(newLocation)

        if let document = OPMLParser().parse(url: newLocation) {
            let markdown = MarkdownGenerator().start(document: document)
            let filename = newLocation.deletingPathExtension().lastPathComponent
            let markdownFileLocation = writeMarkdownToFile(markdown, named: filename)
            openUlysses(for: markdownFileLocation)
        }
    }

    private func addDocumentToModel(_ url: URL) {
        // Remove duplicates
        if let index = self.documents.firstIndex(of: url) {
            self.documents.remove(at: index)
        }
        // insert new item
        self.documents.append(url)
    }

    private func writeMarkdownToFile(_ markdown: MarkdownDocument, named filename: String) -> URL {
        // Construct new location url
        let markdownFileLocation = FileManager.default.temporaryDirectory.appending(component: "\(filename).md")
        // Overwrite existing file
        if FileManager.default.fileExists(atPath: markdownFileLocation.path) {
            try? FileManager.default.removeItem(atPath: markdownFileLocation.path)
        }

        // Write to file
        try? markdown.content.write(to: markdownFileLocation, atomically: true, encoding: .utf8)

        // Update file attributes to OPML metadata attributes
        let attributes: [FileAttributeKey : Any] = [
            .creationDate: markdown.dateCreated.nsDate,
            .modificationDate: markdown.dateModified.nsDate
        ]
        try? FileManager.default.setAttributes(attributes, ofItemAtPath: markdownFileLocation.relativePath)
        return markdownFileLocation
    }

    private func openUlysses(for fileURL: URL) {
        let ulyssesURL = NSWorkspace().urlsForApplications(toOpen: fileURL).first { url in
            url.lastPathComponent.contains("Ulysses")
        }

        guard let ulyssesURL else { return }
        NSWorkspace().open([fileURL], withApplicationAt: ulyssesURL, configuration: NSWorkspace.OpenConfiguration())
    }
}
