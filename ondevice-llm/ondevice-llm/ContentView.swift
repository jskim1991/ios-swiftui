//
//  ContentView.swift
//  ondevice-llm
//
//  Created by jay on 9/11/26.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var viewModel = LLMModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView() {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.session.transcript, id: \.id) { entry in
                            switch entry {
                            case .prompt(let prompt):
                                MessageView(segments: prompt.segments, isHumanMessage: true)
                                    .transition(.offset(y: 500))
                                    .padding(.trailing)
                            case .response(let response):
                                MessageView(segments: response.segments, isHumanMessage: false)
                            default:
                                EmptyView()
                            }
                        }
                    }
                    .animation(.bouncy, value: viewModel.session.transcript)
                    
                    if viewModel.isAwaitingResponse {
                        if let last = viewModel.session.transcript.last {
                            if case .prompt = last {
                                Text("Thinking...")
                                    .bold()
                                    .opacity(viewModel.isThinking ? 0.5 : 1)
                                    .padding(.leading)
                                    .offset(y: 15)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onAppear {
                                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                                            viewModel.isThinking.toggle()
                                        }
                                    }
                            }
                        }
                    }
                }
                .defaultScrollAnchor(.bottom, for: .sizeChanges)
                .safeAreaPadding(.bottom, 100)
                
                HStack {
                    TextField("Ask me anything", text: $viewModel.inputText, axis: .vertical)
                        .textFieldStyle(.plain)
                        .disabled(viewModel.session.isResponding)
                        .frame(height: 55)
                    
                    Button {
                        viewModel.sendMesssage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(viewModel.session.isResponding ? .gray.opacity(0.6) : .blue)
                    }
                    .disabled(viewModel.inputText.isEmpty || viewModel.session.isResponding)
                }
                .padding(.horizontal)
                .glassEffect(.regular.interactive())
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .navigationTitle("Chat")
        }
    }
}

#Preview {
    ContentView()
}
