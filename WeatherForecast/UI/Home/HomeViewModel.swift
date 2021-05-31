import Foundation
import MapKit

protocol HomeViewModelDelegate: NSObjectProtocol {
    
    func homeViewModel(_ viewModel: HomeViewModel, didSelectBookmarkLocation location: Location)
}

final class HomeViewModel: NSObject {
    
    // MARK: - Initialization
    
    init(bookmarkLocationService: BookmarkLocationService) {
        self.bookmarkLocationService = bookmarkLocationService
        
        super.init()
        
        getAllBookmarkLocations()
    }
    
    // MARK: - Bookmark Location
    
    func bookmarkLocation(_ location: CLLocation) {
        bookmarkLocationService.bookmarkLocation(location) { [weak self] (result: Result<Location, Error>) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let location):
                strongSelf.bookmarkLocations.append(location)
                strongSelf.bookmarkLocationsDidChangeObservationBlock?()
                
            case .failure(let error):
                strongSelf.failToBookmarkLocationObservationBlock?(error)
            }
        }
    }
    
    // MARK: - Delete Location
    
    func deleteLocation(withId id: String) {
        do {
            try bookmarkLocationService.deleteLocation(withId: id)
            bookmarkLocations.removeAll(where: { $0.id == id })
            bookmarkLocationsDidChangeObservationBlock?()
        } catch {
            failToDeleteBookmarkLocationObservationBlock?(error)
        }
    }
    
    // MARK: - Get All Bookmark Locations
    
    func getAllBookmarkLocations() {
        do {
            bookmarkLocations = try bookmarkLocationService.getBookmarkLocations()
            bookmarkLocationsDidChangeObservationBlock?()
        } catch {
            failToBookmarkLocationsObservationBlock?(error)
        }
    }
    
    // MARK: - Select Location
    
    func selectBookmarkLocation(at index: Int) {
        // TODO: Add check to validate index should be less than bookmark list size.
        let location = bookmarkLocations[index]
        delegate?.homeViewModel(self, didSelectBookmarkLocation: location)
    }
    
    // MARK: - Delegate
    
    weak var delegate: HomeViewModelDelegate?
    
    // MARK: - Observations
    
    var bookmarkLocationsDidChangeObservationBlock: (() -> Void)?
    
    var failToBookmarkLocationObservationBlock: ((Error) -> Void)?
    
    var failToBookmarkLocationsObservationBlock: ((Error) -> Void)?
    
    var failToDeleteBookmarkLocationObservationBlock: ((Error) -> Void)?
    
    // MARK: - Properties
    
    private(set) var bookmarkLocations: [Location] = []
    
    // MARK: - Dependencies
    
    private let bookmarkLocationService: BookmarkLocationService
}
