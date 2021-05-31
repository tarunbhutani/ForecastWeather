import Foundation

// DI Container
final class ServiceContainer {
    
    // MARK: - Initialization

    init() { }
    
    // MARK: - Services
    
    private var _bookmarkLocationServicer: BookmarkLocationService?
    var bookmarkLocationServicer: BookmarkLocationService {
        if _bookmarkLocationServicer == nil {
            _bookmarkLocationServicer = DefaultBookmarkLocationService(
                bookmarkLocationRepository: localBookmarkLocationRepository
            )
        }
        
        return _bookmarkLocationServicer!
    }
    
    private var _weatherService: WeatherService?
    var weatherService: WeatherService {
        if _weatherService == nil {
            _weatherService = WeatherService(weatherRepository: weatherRepository)
        }
        return _weatherService!
    }
    
    // MARK: - Repository
    
    private var _localBookmarkLocationRepository: BookmarkLocationRepository?
    var localBookmarkLocationRepository: BookmarkLocationRepository {
        if _localBookmarkLocationRepository == nil {
            _localBookmarkLocationRepository = LocalBookmarkLocationRepository(coreDataStack: coreDataStack)
        }
        
        return _localBookmarkLocationRepository!
    }
    
    private var _weatherRepository: WeatherRepository?
    var weatherRepository: WeatherRepository {
        if _weatherRepository == nil {
            _weatherRepository = RemoteWeatherRepository(networkClient: networkClient)
        }
        return _weatherRepository!
    }
    
    // MARK: - Core Data Stack
    
    private var _coreDataStack: CoreDataStack?
    var coreDataStack: CoreDataStack {
        if _coreDataStack == nil {
            _coreDataStack = CoreDataStack()
        }
        return _coreDataStack!
    }
    
    // MARK: - Network Client
    
    var _networkClient: NetworkClient?
    var networkClient: NetworkClient {
        if _networkClient == nil {
            _networkClient = URLSessionNetworkClient()
        }
        return _networkClient!
    }
}
