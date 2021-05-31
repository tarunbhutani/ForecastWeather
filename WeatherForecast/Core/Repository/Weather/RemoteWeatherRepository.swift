import Foundation

final class RemoteWeatherRepository: NSObject {
    
    // MARK: - Initialization
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Private Properties
    
    // TODO: It's fine to directly hold the reference of network client in repository but in real project, it should be done in separate API classes which is solely responsible to creating request, decoding response, setting query items etc. to achieve the separation of concern for each class.
    private let networkClient: NetworkClient
}

// MARK: - Weather Repository

extension RemoteWeatherRepository: WeatherRepository {
    
    func fetchWeather(
        forCityWithLocation location: Location,
        completionHandler: @escaping (Result<WeatherForecast, Error>) -> Void
    ) {
        let url: URL = Configurations.weatherAPIURL
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let queryItems = [
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.longitude)"),
            URLQueryItem(name: "appid", value: Configurations.apiKey)
        ]
        urlComponents.queryItems = queryItems
        networkClient.request(
            url: urlComponents.url!,
            method: .get
        ) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let weatherForecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    completionHandler(.success(weatherForecast))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
                
            }
        }
    }
}
