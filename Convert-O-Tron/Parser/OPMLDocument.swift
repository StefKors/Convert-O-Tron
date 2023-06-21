//
//  OPMLDocument.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 21/06/2023.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    /// A type that represents generic OPML data.
    /// The identifier for this type is com.stefkors.opml.
    /// This type conforms to Upublic.OPML.
    static let opml = UTType("com.stefkors.opml")!
}

final class OPMLDocument: Identifiable, Equatable {
    /// The head content of the document
    var head: OPMLElement? = nil
    /// The body content of the document
    var body: OPMLElement? = nil
    
    // MARK: - Identifiable
    let id = UUID()
    
    // MARK: - Equatable
    static func == (lhs: OPMLDocument, rhs: OPMLDocument) -> Bool {
        lhs.id == rhs.id
    }
}
