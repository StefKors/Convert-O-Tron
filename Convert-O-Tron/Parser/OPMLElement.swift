//
//  OPMLElement.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import Foundation

class OPMLElement: Equatable, Identifiable {
    let id: UUID = UUID()
    var name: Name
    private(set) weak var parent: OPMLElement?
    private(set) lazy var children: [OPMLElement]? = nil

    var breadcrumb: [String] {
        let list = getParent(list: [self], element: self)
        return list.compactMap { element in
            element.attributes[.text]
        }
    }

    func getParent(list: [OPMLElement], element: OPMLElement) -> [OPMLElement] {
        var mutableList = list

        if let parent = element.parent {
            mutableList.insert(parent, at: 0)

            // if the parent has a parent itself recurse up
            if let grandParent = parent.parent {
                return getParent(list: mutableList, element: grandParent)
            }
        }

        return mutableList
    }

    lazy var attributes: [Attribute: String] = [:]

    init?(name: String, attributes: [String: String], parentIsComment: String? = nil) {
        guard let name = Name(rawValue: name) else {
            print("unsupported element name: \(name)")
            return nil
        }
        self.name = name

        var attributeDict: [Attribute: String] = [:]
        for (key, value) in attributes {
            guard let type = Attribute(rawValue: key) else { continue }
            attributeDict[type] = value
        }

        if let parentIsComment {
            attributeDict[.isComment] = parentIsComment
        }

        self.attributes = attributeDict
    }

    func addChild(name: String, attributes: [String: String]) -> OPMLElement? {
        let isComment = self.attributes[.isComment]
        guard let element = OPMLElement(name: name, attributes: attributes, parentIsComment: isComment) else {
            return nil
        }
        element.parent = self

        var childArray = children ?? []
        childArray.append(element)
        children = childArray
        return element
    }

    static func ==(lhs: OPMLElement, rhs: OPMLElement) -> Bool {
        return lhs.name == rhs.name && lhs.attributes == rhs.attributes && lhs.children == rhs.children
    }
}

extension OPMLElement {
    enum Name: String, Codable, CaseIterable {
        case title
        case dateCreated
        case dateModified
        case head
        case body
        case opml
        case outline
    }
}

extension OPMLElement {
    enum Attribute: String, Codable, CaseIterable {
        case text
        case link
        case url
        case type
        case created
        case isComment
        case isBreakpoint
    }
}

extension OPMLElement {
    func findInChildren(id: UUID?) -> OPMLElement? {
        guard let id else { return nil }
        return findRecursive(id, child: self)
    }

    func findRecursive(_ id: UUID, child: OPMLElement) -> OPMLElement? {
        if child.id == id {
            return child
        }

        guard let children = child.children else { return nil }

        for child in children {
            if child.id == id {
                return child
            }

            if let result = findRecursive(id, child: child) {
                return result
            }
        }

        return nil
    }

    func depthFirstFlattened(_ list: [OPMLElement]) -> [OPMLElement] {
        var output = [OPMLElement]()
        for item in list {
            output.append( item )
            if let children = item.children {
                output.append(contentsOf: depthFirstFlattened(children))
            }
        }
        return output
    }
}

extension OPMLElement: CustomDebugStringConvertible {
    var debugDescription: String {
        var children = ""
        if let childs = self.children {
            children = "children(\(childs.count)) ="
            for child in childs {
                children.append("\n\t\(child.debugDescription)")
            }
        }

        let text = self.attributes[.text]
        let str =  "- OPMLElement name = \"\(self.name)\" text = \"\(String(describing: text))\" attributes = \(self.attributes) \(children)"
        return str
    }
}

extension OPMLElement {
    static let previewLink = OPMLElement(name: "outline", attributes: [
        "text": "link example content",
        "url": "https://www.example.com",
        "type": "link"
    ])!

    static let previewPlain = OPMLElement(name: "outline", attributes: ["text": "text content here"])!

    static let previewOptional = OPMLElement(name: "outline", attributes: ["text": "optional element"])

    /// Returns parent with children in following tree:
    /// - parent element
    ///     - child element 1
    ///     - child element 2
    ///         - grandchild element 1
    ///         - grandchild element 2
    ///     - child element 3
    static var previewWithChildren: OPMLElement {
        let parent = OPMLElement(name: "outline", attributes: ["text": "parent element"])!
        _ = parent.addChild(name: "outline", attributes: ["text": "child element 1"])
        let child = parent.addChild(name: "outline", attributes: ["text": "child element 2"])
        _ = parent.addChild(name: "outline", attributes: ["text": "child element 3"])

        _ = child?.addChild(name: "outline", attributes: ["text": "grandchild element 1"])
        _ = child?.addChild(name: "outline", attributes: ["text": "grandchild element 2"])
        return parent
    }

    /// Returns children in following tree:
    /// - [link example content](https://www.example.com)
    /// - parent element
    ///     - child element 1
    ///     - child element 2
    ///         - grandchild element 1
    ///         - grandchild element 2
    ///     - child element 3
    /// - text content here
    static var previewChildren: [OPMLElement] {
        [Self.previewLink, Self.previewWithChildren, Self.previewPlain ]
    }

    static var previewChildrenNil: [OPMLElement]? = nil
}
