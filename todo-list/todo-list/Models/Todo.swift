import Foundation

struct Todo: Codable, Identifiable, Equatable {
    let id: Int
    let description: String
    let finished: Bool
    let tags: [String]
}

struct NewTodoRequest: Encodable {
    let description: String
    let tags: [String]
}
