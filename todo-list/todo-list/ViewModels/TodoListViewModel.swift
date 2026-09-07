import Foundation
import Observation

@MainActor
@Observable
final class TodoListViewModel {
    private(set) var todos: [Todo] = []
    var newTask: String = ""

    private let repository: TodoRepository

    init(repository: TodoRepository) {
        self.repository = repository
    }

    func load() async {
        todos = (try? await repository.fetchTodos()) ?? []
    }

    func addTask() async {
        if newTask.isEmpty {
            return
        }

        guard let created = try? await repository.createTodo(description: newTask) else {
            return
        }

        todos.append(created)
        newTask = ""
    }

    func deleteTask(at offsets: IndexSet) async {
        let removedTodos = offsets.map { todos[$0] }

        for todo in removedTodos {
            try? await repository.deleteTodo(id: todo.id)
        }

        todos.removeAll { removedTodos.contains($0) }
    }
}
