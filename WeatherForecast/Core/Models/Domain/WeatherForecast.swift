import Foundation

struct WeatherForecast: Codable {
    
    let coord: Coordinate
    let weather: [Weather]
    let base: String?
    let main: WeatherMain?
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String?
    let description: String?
}

struct WeatherMain: Codable {
    
    let temp: Double?
    let feels_like: Double?
    let temp_max: Double?
    let pressure: Int?
    let humidity: Int?
    let grnd_level: Int?
}
