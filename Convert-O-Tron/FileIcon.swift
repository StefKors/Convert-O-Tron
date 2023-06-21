//
//  FileIcon.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

import SwiftUI
import UniformTypeIdentifiers

struct FileIcon: View {
    /// Fallsback to plaintext icon
    let type: UTType?
    var body: some View {
        Image(nsImage: NSWorkspace().icon(for: type ?? .plainText))
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct FileIcon_Previews: PreviewProvider {
    static var previews: some View {
        FileIcon(type: .opml)
            .scenePadding()
    }
}
