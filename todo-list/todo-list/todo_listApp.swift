//
//  todo_listApp.swift
//  todo-list
//
//  Created by jay on 8/30/26.
//

import SwiftUI

@main
struct todo_listApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TodoListViewModel(repository: HTTPTodoRepository()))
        }
    }
}
