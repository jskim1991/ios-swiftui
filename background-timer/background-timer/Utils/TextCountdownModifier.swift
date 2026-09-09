//
//  TextCountdownModifier.swift
//  background-timer
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct TextCountdownModifier: ViewModifier {
    @Binding var progress: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(1 + (0.3 * progress))
            .opacity(0.5 + (0.5 + progress))
            .foregroundStyle(progress < 0.3 ? .red : .white)
            .rotationEffect(.degrees((1 - progress) * 360.0))
            .animation(.spring(duration: 0.5), value: progress)
    }
}

extension View {
    func countdownStyle(_ progress: Binding<CGFloat>) -> some View {
        self.modifier(TextCountdownModifier(progress: progress))
    }
}
