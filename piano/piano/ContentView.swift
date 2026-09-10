//
//  ContentView.swift
//  piano
//
//  Created by jay on 9/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = PianoViewModel()
    @State private var currentDragNote: PianoNote?
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Piano App")
                    .font(.title)
                    .padding()
                
                pianoKeyboard(in: geo)
            }
            .background(Color(UIColor.systemBackground))
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        handleDragGesture(value, in: geo)
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
    
    private func handleDragGesture(_ value: DragGesture.Value, in geo: GeometryProxy) {
        let location = value.location
        if let blackNote = findTouchBlackNote(at: location, in: geo) {
            if currentDragNote != blackNote {
                if let previousNote = currentDragNote {
                    viewModel.noteReleased(previousNote)
                }
                currentDragNote = blackNote
                viewModel.notePressed(blackNote)
            }
            return
        }
        
        if let whiteNote = findTouchWhiteNote(at: location, in: geo) {
            if currentDragNote != whiteNote {
                if let previousNote = currentDragNote {
                    viewModel.noteReleased(previousNote)
                }
                currentDragNote = whiteNote
                viewModel.notePressed(whiteNote)
            }
            else if let previousNote = currentDragNote {
                viewModel.noteReleased(previousNote)
                currentDragNote = nil
            }
            return
        }
    }
    
    private func findTouchBlackNote(at location: CGPoint, in geo: GeometryProxy) -> PianoNote? {
        let whiteKeyWidth = geo.size.width / CGFloat(PianoNote.whiteKeys.count)
        let blackKeyWidth = whiteKeyWidth * 0.6
        let blackKeyHeight = geo.size.height * 0.5
        
        for note in PianoNote.blackKeys {
            let index = PianoNote.blackKeys.firstIndex(of: note) ?? 0
            var xOffset: CGFloat
            
            switch index {
            case 0: xOffset = whiteKeyWidth - blackKeyWidth / 2
            case 1: xOffset = whiteKeyWidth * 2 - blackKeyWidth / 2
            case 2: xOffset = whiteKeyWidth * 4 - blackKeyWidth / 2
            case 3: xOffset = whiteKeyWidth * 5 - blackKeyWidth / 2
            case 4: xOffset = whiteKeyWidth * 6 - blackKeyWidth / 2
            default: continue
            }
            
            let keyRect = CGRect(x: xOffset, y: 0, width: blackKeyWidth, height: blackKeyHeight)
            
            if keyRect.contains(location) {
                return note
            }
        }
        
        return nil
    }
    
    private func findTouchWhiteNote(at location: CGPoint, in geo: GeometryProxy) -> PianoNote? {
        let whiteKeyWidth = geo.size.width / CGFloat(PianoNote.whiteKeys.count)
        
        let xIndex = Int(location.x / whiteKeyWidth)
        
        guard xIndex < PianoNote.whiteKeys.count else { return nil }
        return PianoNote.whiteKeys[xIndex]
    }
    
    private func pianoKeyboard(in geo: GeometryProxy) -> some View {
        
        GeometryReader { keyboardGeo in
            ZStack(alignment: .top) {
                HStack(spacing: 1) {
                    ForEach(PianoNote.whiteKeys, id: \.self) { note in
                        PianoKeyView(
                            note: note,
                            isActive: viewModel.isNoteActive(note),
                            onPress: { viewModel.notePressed(note) },
                            onRelease: { viewModel.noteReleased(note) }
                        )
                    }
                }
                .frame(height: keyboardGeo.size.height * 0.8)
            
                
                HStack(spacing: keyboardGeo.size.width / 70) {
                    blackKeySpacers()
                    
                    ForEach(PianoNote.blackKeys, id: \.self) { note in
                        PianoKeyView(
                            note: note,
                            isActive: viewModel.isNoteActive(note),
                            onPress: { viewModel.notePressed(note) },
                            onRelease: { viewModel.noteReleased(note) }
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
