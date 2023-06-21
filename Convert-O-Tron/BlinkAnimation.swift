//
//  BlinkAnimation.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

extension View {
    func blinkAnimation() -> some View {
        return self.modifier(BlinkAnimation())
    }
}

struct BlinkAnimation: ViewModifier {
    private let animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    @State private var isActive = false

    func body(content: Content) -> some View {
        return content
            .opacity(self.isActive ? 1 : 0.0)
            .onAppear {
                withAnimation(self.animation, {
                    self.isActive.toggle()
                })
            }
    }
}

struct BlinkAnimation_Previews: PreviewProvider {
    static var previews: some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 6, dash: [12, 6]))
            .foregroundColor(Color.accentColor)
            .blinkAnimation()
            .frame(width: 150, height: 150)
    }
}
