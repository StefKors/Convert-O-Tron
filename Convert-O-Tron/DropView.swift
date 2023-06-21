//
//  DropView.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

struct DropView: View {
    var label: String
    var body: some View {
        HStack {
            Label(title: {
                Text(label)
            }, icon: {
                FileIcon(type: nil)
                    .frame(maxHeight: 20)
            })
        }
        .frame(width: 300, height: 120, alignment: .center)
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 2)
                .foregroundStyle(.separator)
        }
        .shadow(radius: 20)
        .transition(.opacity.animation(.easeInOut).combined(with: .scale.animation(.interactiveSpring)))
    }
}

struct DropView_Previews: PreviewProvider {
    static var previews: some View {
        DropView(label: "Drop file to import")
            .scenePadding()
    }
}
