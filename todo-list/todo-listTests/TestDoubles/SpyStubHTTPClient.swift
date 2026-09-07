import Foundation
@testable import todo_list

@MainActor
final class SpyStubHTTPClient: HTTPClient {
    private var dataReturnValue = Data()
    private var statusCode = 200

    private(set) var requests: [URLRequest] = []

    func setDataReturnValue(json: String, statusCode: Int = 200) {
        dataReturnValue = Data(json.utf8)
        self.statusCode = statusCode
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        requests.append(request)

        let response = HTTPURLResponse(url: request.url!,
                                       statusCode: statusCode,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: ["Content-Type": "application/json"])!
        return (dataReturnValue, response)
    }
}
