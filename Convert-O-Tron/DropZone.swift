//
//  DropZone.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

import SwiftUI
import UniformTypeIdentifiers

extension View {
    public func dropzone() -> some View {
        return self.modifier(DropzoneView())
    }
}

public struct DropzoneView: ViewModifier {
    @State private var isDropping: Bool = true

    public func body(content: Content) -> some View {
        content
            .background(
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [18, 24]))
                    .rotationAnimation()
                    .blinkAnimation()
                    .background(
                        ZStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.2))

                            Circle()
                                .fill(Color.accentColor.opacity(0.2))
                                .shadow(color: Color.accentColor, radius: 30)
                                .padding(10)
                                .blinkAnimation()
                        }
                    )
                    .foregroundColor(Color.accentColor)
                    .padding(5)
                    .opacity(isDropping ? 1 : 0)
                    .animation(.spring(), value: isDropping)
            )
    }
}

struct DropzoneView_Previews: PreviewProvider {
    static var previews: some View {
        Text("dropzone content")
            .frame(width: 200, height: 200, alignment: .center)
            .dropzone()
            .scenePadding()
    }
}
