import Foundation
import Testing
@testable import todo_list

@MainActor
struct HTTPTodoRepositoryTests {

    private func makeRepository(httpClient: SpyStubHTTPClient) -> HTTPTodoRepository {
        HTTPTodoRepository(baseURL: URL(string: "http://localhost:8080")!, httpClient: httpClient)
    }

    @Test func fetchTodosCallsTodosPathAndDecodesResponse() async throws {
        let httpClient = SpyStubHTTPClient()
        httpClient.setDataReturnValue(json: """
        [{"id":1,"description":"Learn Swift","finished":false,"tags":[]}]
        """)

        let actual = try await makeRepository(httpClient: httpClient).fetchTodos()

        let request = try #require(httpClient.requests.first)
        #expect(request.url?.path == "/api/todos")
        #expect(request.httpMethod == "GET")
        #expect(actual == [Todo(id: 1, description: "Learn Swift", finished: false, tags: [])])
    }

    @Test func createTodoPostsDescriptionWithEmptyTags() async throws {
        let httpClient = SpyStubHTTPClient()
        httpClient.setDataReturnValue(json: """
        {"id":7,"description":"Learn Swift","finished":false,"tags":[]}
        """, statusCode: 201)

        let actual = try await makeRepository(httpClient: httpClient).createTodo(description: "Learn Swift")

        let request = try #require(httpClient.requests.first)
        #expect(request.url?.path == "/api/todos")
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let body = try #require(request.httpBody)
        let sentJson = try #require(try JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(sentJson["description"] as? String == "Learn Swift")
        #expect(sentJson["tags"] as? [String] == [])

        #expect(actual == Todo(id: 7, description: "Learn Swift", finished: false, tags: []))
    }

    @Test func deleteTodoCallsTodoIdPathWithDeleteMethod() async throws {
        let httpClient = SpyStubHTTPClient()
        httpClient.setDataReturnValue(json: "", statusCode: 204)

        try await makeRepository(httpClient: httpClient).deleteTodo(id: 42)

        let request = try #require(httpClient.requests.first)
        #expect(request.url?.path == "/api/todos/42")
        #expect(request.httpMethod == "DELETE")
        #expect(request.httpBody == nil)
    }

    @Test func decodingTodoWithTagsMatchesBackendSchema() async throws {
        let httpClient = SpyStubHTTPClient()
        httpClient.setDataReturnValue(json: """
        [{"id":3,"description":"Buy milk","finished":true,"tags":["errand","home"]}]
        """)

        let actual = try await makeRepository(httpClient: httpClient).fetchTodos()

        #expect(actual == [Todo(id: 3, description: "Buy milk", finished: true, tags: ["errand", "home"])])
    }
}
