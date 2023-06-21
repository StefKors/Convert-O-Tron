//
//  DragAndDropView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

struct DragAndDropView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        if model.isDropping {
            Rectangle().fill(.background.opacity(0.7))
                .transition(.opacity.animation(.easeInOut))
        }
        if model.isDropping {
            if model.isValidFileType {
                DropView(label: "Drop file to import")
            } else {
                DropView(label: "❌ can't import file")
            }
        }

    }
}

struct DragAndDropView_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropView()
            .scenePadding()
    }
}
