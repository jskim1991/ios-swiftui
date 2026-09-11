//
//  LLMModel.swift
//  ondevice-llm
//
//  Created by jay on 9/11/26.
//

import Foundation
import FoundationModels

@Observable
final class LLMModel {
    var inputText: String = ""
    var isThinking: Bool = false
    
    var isAwaitingResponse = false
    var session = LanguageModelSession(instructions: """
        You are a helpful and concise assistant. Provide clear, accurate answers in a professional language.
    """)
    
    func sendMesssage() {
        Task {
            do {
                let prompt = inputText
                inputText = ""
                let stream = session.streamResponse(to: prompt)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isAwaitingResponse = true
                }
                
                for try await line in stream {
                    isAwaitingResponse = false
                    print(line)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
