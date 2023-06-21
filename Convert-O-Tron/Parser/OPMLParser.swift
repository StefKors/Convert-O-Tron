//
//  OPMLParser.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 21/06/2023.
//

import Foundation

class OPMLParser: NSObject, XMLParserDelegate {
    private(set) var document = OPMLDocument()
    private var root: OPMLElement?
    private var currentParent: OPMLElement?
    private var currentElement: OPMLElement?
    private var currentValue = ""
    private var parseError: Error?

    func parse(url: URL) -> OPMLDocument? {
        let parser = XMLParser(contentsOf: url)!
        return self.parse(parser)
    }

    func parse(string: String) -> OPMLDocument? {
        let parser = XMLParser(data: string.data(using: .utf8)!)
        return self.parse(parser)
    }

    private func parse(_ parser: XMLParser) -> OPMLDocument? {
        parser.delegate = self
        parser.parse()
        return document
    }

    @objc func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = currentParent?.addChild(name: elementName, attributes: attributeDict) ?? OPMLElement(name: elementName, attributes: attributeDict)

        if currentElement?.name == .head, document.head == nil {
            document.head = currentElement
        }

        if currentElement?.name == .body, document.body == nil {
            document.body = currentElement
        }

        currentParent = currentElement
    }

    @objc func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
        let newValue = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if !newValue.isEmpty {
            currentElement?.attributes[.text] = newValue
        }
    }

    @objc func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentParent = currentParent?.parent
        currentElement = nil
        currentValue = ""
    }

    @objc func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseError = parseError
    }
}
