import Testing
import SwiftUI
import ViewInspector
@testable import todo_list

actor FakeTodoRepository: TodoRepository {
    private var storedTodos: [Todo]
    private var nextId: Int

    private(set) var createdDescriptions: [String] = []
    private(set) var createdTags: [[String]] = []
    private(set) var deletedIds: [Int] = []

    init(storedTodos: [Todo] = []) {
        self.storedTodos = storedTodos
        self.nextId = (storedTodos.map(\.id).max() ?? 0) + 1
    }

    func fetchTodos() async throws -> [Todo] {
        storedTodos
    }

    func createTodo(description: String) async throws -> Todo {
        createdDescriptions.append(description)
        createdTags.append([])

        let created = Todo(id: nextId, description: description, finished: false, tags: [])
        nextId += 1
        storedTodos.append(created)
        return created
    }

    func deleteTodo(id: Int) async throws {
        deletedIds.append(id)
        storedTodos.removeAll { $0.id == id }
    }
}

@MainActor
struct TodoListAppTests {

    @Test func rendersNewTaskFieldAndAddButton() throws {
        let todoList = TodoListApp(viewModel: TodoListViewModel(repository: FakeTodoRepository()))

        let textField = try todoList.inspect().find(ViewType.TextField.self)
        #expect(try textField.labelView().text().string() == "New task")

        let buttonIcon = try todoList.inspect().find(ViewType.Image.self).actualImage()
        #expect(try buttonIcon.name() == "plus.circle.fill")
    }

    @Test func addingTaskRendersItAndClearsInput() async throws {
        let repository = FakeTodoRepository()
        let viewModel = TodoListViewModel(repository: repository)
        viewModel.newTask = "Learn Swift"

        await viewModel.addTask()

        #expect(viewModel.todos.map(\.description) == ["Learn Swift"])
        #expect(viewModel.newTask == "")
        #expect(await repository.createdTags == [[]])

        let todoList = TodoListApp(viewModel: viewModel)
        #expect(try todoList.inspect().find(text: "Learn Swift").string() == "Learn Swift")
        #expect(try todoList.inspect().find(ViewType.TextField.self).input() == "")
    }

    @Test func addingEmptyTaskDoesNotReachBackend() async throws {
        let repository = FakeTodoRepository()
        let viewModel = TodoListViewModel(repository: repository)
        viewModel.newTask = ""

        await viewModel.addTask()

        #expect(viewModel.todos.isEmpty)
        #expect(await repository.createdDescriptions.isEmpty)
    }

    @Test func deletingTaskRemovesItAndReachesBackend() async throws {
        let repository = FakeTodoRepository(storedTodos: [
            Todo(id: 1, description: "Learn Kotlin", finished: false, tags: []),
            Todo(id: 2, description: "Learn iOS", finished: false, tags: []),
        ])
        let viewModel = TodoListViewModel(repository: repository)
        await viewModel.load()

        await viewModel.deleteTask(at: IndexSet(integer: 0))

        #expect(viewModel.todos.map(\.description) == ["Learn iOS"])
        #expect(await repository.deletedIds == [1])

        let todoList = TodoListApp(viewModel: viewModel)
        #expect(throws: Error.self) {
            try todoList.inspect().find(text: "Learn Kotlin")
        }
    }
}
