import Foundation
@testable import todo_list

@MainActor
final class SpyStubTodoRepository: TodoRepository {
    private var fetchTodosReturnValue: [Todo] = []
    private var createTodoReturnValue: Todo?

    private(set) var fetchTodosCallCount = 0
    private(set) var createTodoArguments: [String] = []
    private(set) var createTodoTags: [[String]] = []
    private(set) var deleteTodoArguments: [Int] = []

    func setFetchTodosReturnValue(_ todos: [Todo]) {
        fetchTodosReturnValue = todos
    }

    func setCreateTodoReturnValue(_ todo: Todo) {
        createTodoReturnValue = todo
    }

    func fetchTodos() async throws -> [Todo] {
        fetchTodosCallCount += 1
        return fetchTodosReturnValue
    }

    func createTodo(description: String) async throws -> Todo {
        createTodoArguments.append(description)
        createTodoTags.append([])

        guard let createTodoReturnValue else {
            throw StubError.missingReturnValue("createTodo")
        }

        return createTodoReturnValue
    }

    func deleteTodo(id: Int) async throws {
        deleteTodoArguments.append(id)
    }
}

enum StubError: Error {
    case missingReturnValue(String)
}
