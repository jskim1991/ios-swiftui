//
//  ContentView.swift
//  todo-list-swiftdata
//
//  Created by jay on 9/10/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todos: [Todo]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in
                    Text(todo.title)
                        .font(.title)
                        .foregroundStyle(todo.completed ? .gray : .primary)
                        .strikethrough(todo.completed, pattern: .dash, color: .gray)
                }
                
            }
            Button("Add new data") {
                modelContext.insert(Todo(title: "Learn something", completed: false))
            }
        }
        .navigationTitle("Todo List")
    }
}

#Preview {
    ContentView()
        .modelContainer(Todo.stub)
}
