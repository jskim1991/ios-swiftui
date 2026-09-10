//
//  Todo.swift
//  todo-list-swiftdata
//
//  Created by jay on 9/10/26.
//

import Foundation
import SwiftData

@Model
final class Todo {
    var title: String
    var completed: Bool
    
    init(title: String, completed: Bool) {
        self.title = title
        self.completed = completed
    }
}

extension Todo {
    
    @MainActor
    static var stub: ModelContainer {
        let container = try! ModelContainer(for: Todo.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(Todo(title: "Learn Kotlin", completed: true))
        container.mainContext.insert(Todo(title: "Learn Swift", completed: false))
        
        return container
    }
}
