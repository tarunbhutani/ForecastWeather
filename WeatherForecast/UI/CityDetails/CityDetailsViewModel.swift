import Foundation

final class CityDetailsViewModel: NSObject {
    
    // MARK: - Initialization
    
    init(weatherService: WeatherService, location: Location) {
        self.weatherService = weatherService
        self.location = location
        
        super.init()
        
        fetchLocation()
    }
    
    // MARK: - Fetch Location
    
    private func fetchLocation() {
        weatherService.fetchWeather(forCityWithLocation: location) { [weak self] (result: Result<WeatherForecast, Error>) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let forecast):
                let presentation = Presentation(
                    name: strongSelf.location.name,
                    temperature: forecast.main?.temp != nil ? "\(forecast.main!.temp!)" : "N/A",
                    humidity: forecast.main?.humidity != nil ? "\(forecast.main!.humidity!)" : "N/A")
                strongSelf.presentationState = .loaded(presentation)
                
            case .failure(let error):
                strongSelf.presentationState = .loadingFailed(error)
            }
            strongSelf.presentationStateDidChangeObservationBlock?(strongSelf.presentationState)
        }
    }
    
    // MARK: - Observations
    
    var presentationStateDidChangeObservationBlock: ((_ state: DataLoadingPresentation<Presentation>) -> Void)?
    
    // MARK: - State Properties
    
    private(set) var presentationState: DataLoadingPresentation<Presentation> = .loading
    
    // MARK: - Private Properties
    
    private let location: Location
    
    // MARK: - Dependencies
    
    private let weatherService: WeatherService
    
    // MARK: - Presentation
    
    struct Presentation: Equatable {
        let name: String
        
        let temperature: String
        
        let humidity: String
    }
}
