import Foundation
import MapKit

enum BookmarkLocationError: Error {
    case failToGeocodeLocation
}

protocol BookmarkLocationService: NSObjectProtocol {
    
    func bookmarkLocation(
        _ location: CLLocation,
        completionHandler: @escaping (Result<Location, Error>) -> Void
    )
    
    func getBookmarkLocations() throws -> [Location]
    
    func deleteLocation(withId id: String) throws
}

/// `BookmarkLocationService` is responsible to manage all kind of I/O operations related to location bookmark.
final class DefaultBookmarkLocationService: NSObject, BookmarkLocationService {
    
    // MARK: - Initialziation
    
    init(bookmarkLocationRepository: BookmarkLocationRepository) {
        self.bookmarkLocationRepository = bookmarkLocationRepository
    }
    
    // MARK: - Add Bookmark
    
    func bookmarkLocation(
        _ location: CLLocation,
        completionHandler: @escaping (Result<Location, Error>) -> Void
    ) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placeMarks, error) in
            guard let strongSelf = self else { return }
            
            if let placeMark = placeMarks?.first, let locality = placeMark.locality {
                let location = Location(
                    id: UUID().uuidString,
                    name: locality,
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                
                do {
                    try strongSelf.bookmarkLocationRepository.bookmarkLocation(location)
                    completionHandler(.success(location))
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                completionHandler(.failure(BookmarkLocationError.failToGeocodeLocation))
            }
        }
    }
    
    // MARK: - Get Bookmark Locations
    
    func getBookmarkLocations() throws -> [Location] {
        do {
            return try bookmarkLocationRepository.getAllBookmarkLocations()
        } catch {
            throw error
        }
    }
    
    // MARK: - Delete Location
    
    func deleteLocation(withId id: String) throws {
        do {
            try bookmarkLocationRepository.deleteLocation(withId: id)
        } catch {
            throw error
        }
    }
    
    // MARK: - Private Properties
    
    // MARK: - Dependencies
    
    private let bookmarkLocationRepository: BookmarkLocationRepository
}
