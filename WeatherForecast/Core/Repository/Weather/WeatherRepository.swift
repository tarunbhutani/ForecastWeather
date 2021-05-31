import Foundation

protocol WeatherRepository: NSObjectProtocol {
    
    func fetchWeather(forCityWithLocation location: Location, completionHandler: @escaping (Result<WeatherForecast, Error>) -> Void)
}
