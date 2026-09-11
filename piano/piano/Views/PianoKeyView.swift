//
//  PianoKeyView.swift
//  piano
//
//  Created by jay on 9/10/26.
//

import SwiftUI

struct PianoKeyView: View {
    let note: PianoNote
    let isActive: Bool

    private var keyColor: Color {
        if isActive {
            return .pianoHighlightColor.opacity(0.8)
        }

        return note.isBlackKey ? .pianoBlackKey : .pianoWhiteKey
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 3)
                .offset(y: 3)

            Rectangle()
                .fill(keyColor)
                .overlay {
                    Rectangle()
                        .stroke(.black.opacity(0.2), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.2), radius: isActive ? 0 : 1, x: 0, y: isActive ? 0 : -1)
                .offset(y: isActive ? 0 : -2)
        }
        .background {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: KeyFramePreferenceKey.self,
                    value: [KeyFrame(note: note, rect: proxy.frame(in: .named("keyboard")))]
                )
            }
        }
    }
}

#Preview {
    PianoKeyView(
        note: PianoNote(midiNote: 60, name: "C4", isBlackKey: false),
        isActive: true
    )
}
