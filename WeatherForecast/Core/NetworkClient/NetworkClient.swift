import Foundation

typealias HTTPHeaders = [String: String]

extension URLRequest {

    public enum HTTPMethod: String {
        case options = "OPTIONS"
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
    }
}

struct NetworkBody {
    let data: Any?

    init() {
        self.data = nil
    }

    init(data: Any) {
        self.data = data
    }
}

enum NetworkClientError: Error {
    case unknownError
}

protocol NetworkClient: NSObjectProtocol {
    
    func request(url: URL, method: URLRequest.HTTPMethod, completionHandler: @escaping (Result<Data, Error>) -> Void)
}

