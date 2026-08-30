//
//  ContentView.swift
//  todo-list
//
//  Created by jay on 8/30/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TodoListApp()
    }
}

struct TodoListApp: View {
    @State private var tasks: [String] = ["Learn Kotlin", "Learn iOS", "Learn Spring"]
    @State private var newTask: String = ""
    
    var body: some View {
        NavigationStack {
            HStack {
                TextField("New task", text: $newTask)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                
                Button(action: addTask) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundStyle(.blue)
                }
                .padding(.trailing)
            }
            .padding()
            
            List {
                ForEach(tasks, id: \.self) { task in
                    Text(task)
                }
                .onDelete(perform: deleteTask(at:))
            }
            .navigationTitle("Todo List")
        }
    }
    
    func addTask() {
        if newTask.isEmpty {
            return
        }
        
        tasks.append(newTask)
        newTask = ""
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
