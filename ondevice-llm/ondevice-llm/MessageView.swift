//
//  MessageView.swift
//  ondevice-llm
//
//  Created by jay on 9/11/26.
//

import SwiftUI
import FoundationModels

struct MessageView: View {
    let segments: [Transcript.Segment]
    let isHumanMessage: Bool
    
    var body: some View {
        VStack {
            ForEach(segments, id: \.id) { seg in
                switch seg {
                case .text(let text):
                    if let textContent = try? AttributedString(styledMarkdown: text.content) {
                        Text(textContent)
                            .padding(10)
                            .background(isHumanMessage ? .blue : .clear, in: .rect(cornerRadius: 20))
                            .foregroundStyle(isHumanMessage ? .white : .primary)
                            .frame(maxWidth: .infinity, alignment: isHumanMessage ? .trailing : .leading)
                    } else {
                        Text(text.content)
                            .padding(10)
                            .background(isHumanMessage ? .blue : .clear, in: .rect(cornerRadius: 20))
                            .foregroundStyle(isHumanMessage ? .white : .primary)
                            .frame(maxWidth: .infinity, alignment: isHumanMessage ? .trailing : .leading)
                    }
                case .structure(let structure):
                    Text(structure.description)
                    
                @unknown default:
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
