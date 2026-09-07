import Foundation
import Testing
@testable import todo_list

final class StubURLProtocol: URLProtocol {
    struct Stub {
        let statusCode: Int
        let body: Data
    }

    nonisolated(unsafe) static var stub = Stub(statusCode: 200, body: Data())
    nonisolated(unsafe) static var capturedRequests: [URLRequest] = []

    static func reset() {
        stub = Stub(statusCode: 200, body: Data())
        capturedRequests = []
    }

    static func respond(statusCode: Int = 200, json: String) {
        stub = Stub(statusCode: statusCode, body: Data(json.utf8))
    }

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        var captured = request
        if let stream = request.httpBodyStream {
            stream.open()
            var body = Data()
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            defer { buffer.deallocate() }
            while stream.hasBytesAvailable {
                let read = stream.read(buffer, maxLength: bufferSize)
                if read <= 0 { break }
                body.append(buffer, count: read)
            }
            stream.close()
            captured.httpBody = body
        }
        Self.capturedRequests.append(captured)

        let response = HTTPURLResponse(url: request.url!,
                                       statusCode: Self.stub.statusCode,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: ["Content-Type": "application/json"])!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.stub.body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

@Suite(.serialized)
struct HTTPTodoRepositoryTests {

    private func makeRepository() -> HTTPTodoRepository {
        StubURLProtocol.reset()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return HTTPTodoRepository(baseURL: URL(string: "http://localhost:8080")!,
                                  session: URLSession(configuration: configuration))
    }

    @Test func fetchTodosCallsTodosPathAndDecodesResponse() async throws {
        let repository = makeRepository()
        StubURLProtocol.respond(json: """
        [{"id":1,"description":"Learn Swift","finished":false,"tags":[]}]
        """)

        let todos = try await repository.fetchTodos()

        let request = try #require(StubURLProtocol.capturedRequests.first)
        #expect(request.url?.path == "/api/todos")
        #expect(request.httpMethod == "GET")
        #expect(todos == [Todo(id: 1, description: "Learn Swift", finished: false, tags: [])])
    }

    @Test func createTodoPostsDescriptionWithEmptyTags() async throws {
        let repository = makeRepository()
        StubURLProtocol.respond(statusCode: 201, json: """
        {"id":7,"description":"Learn Swift","finished":false,"tags":[]}
        """)

        let created = try await repository.createTodo(description: "Learn Swift")

        let request = try #require(StubURLProtocol.capturedRequests.first)
        #expect(request.url?.path == "/api/todos")
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")

        let body = try #require(request.httpBody)
        let sentJson = try #require(try JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(sentJson["description"] as? String == "Learn Swift")
        #expect(sentJson["tags"] as? [String] == [])

        #expect(created == Todo(id: 7, description: "Learn Swift", finished: false, tags: []))
    }

    @Test func deleteTodoCallsTodoIdPathWithDeleteMethod() async throws {
        let repository = makeRepository()
        StubURLProtocol.respond(statusCode: 204, json: "")

        try await repository.deleteTodo(id: 42)

        let request = try #require(StubURLProtocol.capturedRequests.first)
        #expect(request.url?.path == "/api/todos/42")
        #expect(request.httpMethod == "DELETE")
        #expect(request.httpBody == nil)
    }

    @Test func decodingTodoWithTagsMatchesBackendSchema() async throws {
        let repository = makeRepository()
        StubURLProtocol.respond(json: """
        [{"id":3,"description":"Buy milk","finished":true,"tags":["errand","home"]}]
        """)

        let todos = try await repository.fetchTodos()

        #expect(todos == [Todo(id: 3, description: "Buy milk", finished: true, tags: ["errand", "home"])])
    }
}
