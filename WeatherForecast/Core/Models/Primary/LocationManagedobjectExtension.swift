import Foundation

extension LocationManagedObject: DomainModel {
    
    func toDomainModel() -> Location {
        return Location(id: id!, name: name!, latitude: latitude, longitude: longitude)
    }
}
