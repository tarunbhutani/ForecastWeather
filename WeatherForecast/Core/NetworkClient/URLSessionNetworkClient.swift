import Foundation

final class URLSessionNetworkClient: NSObject, NetworkClient {
    
    func request(
        url: URL,
        method: URLRequest.HTTPMethod,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Accept-Encoding", forHTTPHeaderField: "gzip")

        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            } else if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(NetworkClientError.unknownError))
            }
        }

        dataTask.resume()
    }
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
}
