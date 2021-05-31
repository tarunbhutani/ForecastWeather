import Foundation

protocol HomeCollectionCellViewModelDelegate: NSObjectProtocol {
    
    func deleteLocation(withId id: String)
}

final class HomeCollectionCellViewModel: NSObject {
    
    // MARK: - Initialization
    
    init(location: Location) {
        self.location = location
    }
    
    // MARK: - Presentations
    
    var name: String {
        return location.name
    }
    
    var coordinates: String {
        return "\(location.latitude), \(location.longitude)"
    }
    
    // MARK: - Actions
    
    func deleteLocation() {
        delegate?.deleteLocation(withId: location.id)
    }
    
    // MARK: - Delegate
    
    weak var delegate: HomeCollectionCellViewModelDelegate?
    
    // MARK: - Private Properties
    
    private let location: Location
}
