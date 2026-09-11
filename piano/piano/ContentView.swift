//
//  ContentView.swift
//  piano
//
//  Created by jay on 9/10/26.
//

import SwiftUI

struct KeyFrame: Equatable {
    let note: PianoNote
    let rect: CGRect
}

struct KeyFramePreferenceKey: PreferenceKey {
    static var defaultValue: [KeyFrame] = []
    static func reduce(value: inout [KeyFrame], nextValue: () -> [KeyFrame]) {
        value.append(contentsOf: nextValue())
    }
}

struct ContentView: View {
    @State private var viewModel = PianoViewModel()
    @State private var currentDragNote: PianoNote?
    @State private var keyFrames: [KeyFrame] = []
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Piano App")
                    .font(.title)
                    .padding()
                
                pianoKeyboard(in: geo)
            }
            .background(Color(UIColor.systemBackground))
            .coordinateSpace(name: "keyboard")
            .onPreferenceChange(KeyFramePreferenceKey.self) { frames in
                keyFrames = frames
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("keyboard"))
                    .onChanged({ value in
                        handleDragGesture(at: value.location)
                    })
                    .onEnded({ _ in
                        if let note = currentDragNote {
                            viewModel.noteReleased(note)
                            currentDragNote = nil
                        }
                    })
            )
        }
        .ignoresSafeArea()
        .statusBarHidden()
        .preferredColorScheme(.dark)
    }
    
    private func handleDragGesture(at location: CGPoint) {
        let note = keyFrames.first(where: { $0.note.isBlackKey && $0.rect.contains(location) })?.note
            ?? keyFrames.first(where: { $0.rect.contains(location) })?.note

        guard note != currentDragNote else { return }

        if let previousNote = currentDragNote {
            viewModel.noteReleased(previousNote)
        }
        currentDragNote = note
        if let note {
            viewModel.notePressed(note)
        }
    }
    
    private func pianoKeyboard(in geo: GeometryProxy) -> some View {
        
        GeometryReader { keyboardGeo in
            ZStack(alignment: .top) {
                HStack(spacing: 1) {
                    ForEach(PianoNote.whiteKeys, id: \.self) { note in
                        PianoKeyView(
                            note: note,
                            isActive: viewModel.isNoteActive(note)
                        )
                    }
                }
                .frame(height: keyboardGeo.size.height * 0.8)
            
                
                HStack(spacing: keyboardGeo.size.width / 70) {
                    blackKeySpacers()
                    
                    ForEach(PianoNote.blackKeys, id: \.self) { note in
                        PianoKeyView(
                            note: note,
                            isActive: viewModel.isNoteActive(note)
                        )
                        
                        if note.midiNote == 63 {
                            blackKeySpacers()
                            blackKeySpacers()
                        }
                    }
                    blackKeySpacers()
                    
                }
                .frame(height: keyboardGeo.size.height * 0.5)
                .zIndex(1)
            }
            
        }
    }
    
    private func blackKeySpacers() -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: 30)
    }
}

#Preview {
    ContentView()
}
