//
//  PianoViewModel.swift
//  piano
//
//  Created by jay on 9/10/26.
//

import SwiftUI
import AudioKit

@MainActor
@Observable
final class PianoViewModel {
    private(set) var activeNotes: Set<MIDINoteNumber> = []
    private let audioManager: AudioManager = AudioManager.shared
    
    init() {
        Task {
            do {
                try await audioManager.setupAudio()
            } catch {
                print("Audio setup failed: \(error)")
            }
        }
    }
    
    func notePressed(_ note: PianoNote) {
        guard !activeNotes.contains(note.midiNote) else { return }
        activeNotes.insert(note.midiNote)
        Task {
            await audioManager.playNote(note: note.midiNote)
        }
    }
    
    func noteReleased(_ note: PianoNote) {
        activeNotes.remove(note.midiNote)
        Task {
            await audioManager.stopNote(note: note.midiNote)
        }
    }
    
    func isNoteActive(_ note: PianoNote) -> Bool {
        return activeNotes.contains(note.midiNote)
    }
}
