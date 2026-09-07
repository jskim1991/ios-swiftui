//
//  ContentView.swift
//  todo-list
//
//  Created by jay on 8/30/26.
//

import SwiftUI

struct ContentView: View {
    let viewModel: TodoListViewModel

    var body: some View {
        TodoListApp(viewModel: viewModel)
    }
}

struct TodoListApp: View {
    @State var viewModel: TodoListViewModel

    var body: some View {
        NavigationStack {
            HStack {
                TextField("New task", text: $viewModel.newTask)
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
                ForEach(viewModel.todos) { todo in
                    Text(todo.description)
                }
                .onDelete(perform: deleteTask(at:))
            }
            .navigationTitle("Todo List")
        }
        .task {
            await viewModel.load()
        }
    }
    
    func addTask() {
        Task {
            await viewModel.addTask()
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        Task {
            await viewModel.deleteTask(at: offsets)
        }
    }
}

#Preview {
    ContentView(viewModel: TodoListViewModel(repository: HTTPTodoRepository()))
}
