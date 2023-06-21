//
//  RotateAnimation.swift
//  Convert-O-Tron
//
//  Created by Stef Kors on 22/06/2023.
//

import SwiftUI

extension View {
    func rotationAnimation() -> some View {
        return self.modifier(RotationAnimation())
    }
}

struct RotationAnimation: ViewModifier {
    private let animation = Animation.linear(duration: 60.0).repeatForever(autoreverses: false)
    @State private var isActive = false

    func body(content: Content) -> some View {
        return content
            .rotationEffect(Angle(degrees: self.isActive ? 360.0 : 0.0))
            .onAppear {
                withAnimation(self.animation, {
                    self.isActive.toggle()
                })
            }
    }
}

struct RotateAnimation_Previews: PreviewProvider {
    static var previews: some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 6, dash: [12, 6]))
            .foregroundColor(Color.accentColor)
            .rotationAnimation()
            .frame(width: 150, height: 150)
    }
}
