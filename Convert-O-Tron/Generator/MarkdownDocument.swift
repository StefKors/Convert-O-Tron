//
//  MarkdownDocument.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import Foundation

class MarkdownDocument {
    /// The ti­tle of the doc­u­ment
    var title: String? = nil
    /// The cre­ation date of the doc­u­ment
    var dateCreated: Date = .now
    /// The last mod­i­fi­ca­tion date of the doc­u­ment
    var dateModified: Date = .now
    // The main content of the document
    var content: String = ""
}
