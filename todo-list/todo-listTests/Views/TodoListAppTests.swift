import Testing
import SwiftUI
import ViewInspector
@testable import todo_list

@MainActor
struct TodoListAppTests {

    @Test func rendersNewTaskFieldAndAddButton() throws {
        let todoList = TodoListApp(viewModel: TodoListViewModel(repository: SpyStubTodoRepository()))

        let textField = try todoList.inspect().find(ViewType.TextField.self)
        #expect(try textField.labelView().text().string() == "New task")

        let buttonIcon = try todoList.inspect().find(ViewType.Image.self).actualImage()
        #expect(try buttonIcon.name() == "plus.circle.fill")
    }

    @Test func addingTaskRendersItAndClearsInput() async throws {
        let repository = SpyStubTodoRepository()
        repository.setCreateTodoReturnValue(Todo(id: 1, description: "Learn Swift", finished: false, tags: []))
        let viewModel = TodoListViewModel(repository: repository)
        viewModel.newTask = "Learn Swift"

        await viewModel.addTask()

        #expect(repository.createTodoArguments == ["Learn Swift"])
        #expect(repository.createTodoTags == [[]])
        #expect(viewModel.todos.map(\.description) == ["Learn Swift"])
        #expect(viewModel.newTask == "")

        let todoList = TodoListApp(viewModel: viewModel)
        #expect(try todoList.inspect().find(text: "Learn Swift").string() == "Learn Swift")
        #expect(try todoList.inspect().find(ViewType.TextField.self).input() == "")
    }

    @Test func addingEmptyTaskDoesNotReachBackend() async throws {
        let repository = SpyStubTodoRepository()
        let viewModel = TodoListViewModel(repository: repository)
        viewModel.newTask = ""

        await viewModel.addTask()

        #expect(repository.createTodoArguments.isEmpty)
        #expect(viewModel.todos.isEmpty)
    }

    @Test func deletingTaskRemovesItAndReachesBackend() async throws {
        let repository = SpyStubTodoRepository()
        repository.setFetchTodosReturnValue([
            Todo(id: 1, description: "Learn Kotlin", finished: false, tags: []),
            Todo(id: 2, description: "Learn iOS", finished: false, tags: []),
        ])
        let viewModel = TodoListViewModel(repository: repository)
        await viewModel.load()

        await viewModel.deleteTask(at: IndexSet(integer: 0))

        #expect(repository.deleteTodoArguments == [1])
        #expect(viewModel.todos.map(\.description) == ["Learn iOS"])

        let todoList = TodoListApp(viewModel: viewModel)
        #expect(throws: Error.self) {
            try todoList.inspect().find(text: "Learn Kotlin")
        }
    }

}
