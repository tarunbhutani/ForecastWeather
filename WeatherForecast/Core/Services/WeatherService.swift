import Foundation

final class WeatherService: NSObject {
    
    // MARK: - Initialization
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    // MARK: - Fetch City Forcast
    
    func fetchWeather(
        forCityWithLocation location: Location,
        completionHandler: @escaping (Result<WeatherForecast, Error>) -> Void
    ) {
        weatherRepository.fetchWeather(
            forCityWithLocation: location
        ) { (result: Result<WeatherForecast, Error>) in
            switch result {
            case .success(let weatherForecast):
                DispatchQueue.main.async {
                    completionHandler(.success(weatherForecast))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Dependencies
    
    let weatherRepository: WeatherRepository
}
