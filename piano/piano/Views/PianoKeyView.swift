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
    let onPress: () -> Void
    let onRelease: () -> Void
    
    @State private var isDragging = false
    
    private var baseColor: Color {
        note.isBlackKey ? .black.opacity(0.6) : .gray.opacity(0.3)
    }
    
    private var keyColor: Color {
        if isActive {
            return .pianoHighlightColor.opacity(0.8)
        }
        
        return note.isBlackKey ? .pianoBlackKey : .pianoWhiteKey
    }
    
    var body: some View {
        GeometryReader { geometry in
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
                    .shadow(color: .black.opacity(0.2), radius: isDragging ? 0 : 1, x: 0, y: isDragging ? 0 : -1)
                    .offset(y: isDragging ? 0 : -2)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        if isDragging == false {
                            isDragging = true
                            onPress()
                        }
                    })
                    .onEnded({ _ in
                        isDragging = false
                        onRelease()
                    })
            )
        }
    }
}

#Preview {
    PianoKeyView(
        note: PianoNote(midiNote: 60, name: "C4", isBlackKey: false),
        isActive: true,
        onPress: {},
        onRelease: {}
    )
}
