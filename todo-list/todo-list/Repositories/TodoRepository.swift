import Foundation

protocol TodoRepository: Sendable {
    func fetchTodos() async throws -> [Todo]
    func createTodo(description: String) async throws -> Todo
    func deleteTodo(id: Int) async throws
}

struct HTTPTodoRepository: TodoRepository {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL = URL(string: "http://localhost:8080")!, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func fetchTodos() async throws -> [Todo] {
        let (data, _) = try await session.data(from: todosURL)
        return try JSONDecoder().decode([Todo].self, from: data)
    }

    func createTodo(description: String) async throws -> Todo {
        var request = URLRequest(url: todosURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(NewTodoRequest(description: description, tags: []))
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(Todo.self, from: data)
    }

    func deleteTodo(id: Int) async throws {
        var request = URLRequest(url: todosURL.appending(path: "\(id)"))
        request.httpMethod = "DELETE"
        _ = try await session.data(for: request)
    }

    private var todosURL: URL {
        baseURL.appending(path: "api/todos")
    }
}
