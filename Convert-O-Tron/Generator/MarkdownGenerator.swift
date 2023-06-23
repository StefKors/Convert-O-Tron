//
//  MarkdownGenerator.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 21/06/2023.
//

import Foundation

class MarkdownGenerator {
    var mdDocument = MarkdownDocument()
    var depth: Int = 0

    func start(document: OPMLDocument) -> MarkdownDocument {
        if let head = document.head {
            generateMetadata(children: head.children)
        }
        if let body = document.body {
            generateContent(children: body.children)
        }
        return mdDocument
    }

    private func generateMetadata(children: [OPMLElement]?) {
        guard let children else { return }
        for child in children {
            if child.name == .title {
                if let title = child.attributes[.text]?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    mdDocument.title = title
                    mdDocument.content += "# \(title)"
                    mdDocument.content += "\n"
                }
            }

            if child.name == .dateCreated {
                mdDocument.dateCreated = getDate(child) ?? .now
            }

            if child.name == .dateModified {
                mdDocument.dateModified = getDate(child) ?? .now
            }

            // Recurse
            if let children = child.children {
                generateMetadata(children: children)
            }
        }
    }

    private func getDate(_ child: OPMLElement) -> Date? {
        guard let stringDate = child.attributes[.text] else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        return formatter.date(from: stringDate)
    }

    private func generateContent(children: [OPMLElement]?) {
        guard let children else { return }
        depth = depth + 1
        for child in children {
            if let wrappedContent = applyAttributes(element: child) {
                mdDocument.content += wrappedContent
                mdDocument.content += "\n"

                // Recurse
                if let children = child.children {
                    generateContent(children: children)
                }
            }
        }

        depth = depth - 1
    }

    private func applyAttributes(element: OPMLElement) -> String? {
        if let isComment = element.attributes[.isComment], isComment == "true" {
            return nil
        }
        guard var text = element.attributes[.text]?.trimmingCharacters(in: .whitespacesAndNewlines) else { return "" }

        // Handle outline depth
        if element.name == .outline {
            // Headings 2 - 6
            if depth < 6 {
                let heading = String(repeating: "#", count: depth)
                text = "#\(heading) \(text)"
            } else {
                // Indent if more than H6
                let indent = String(repeating: "\t", count: depth - 5)
                text = "\(indent)- \(text)"
            }
        }

        // Handle link
        if let type = element.attributes[.type],
           type == "link",
           let url = element.attributes[.url] {
            text = "[\(text)](\(url))"
        }

        return text
    }
}
