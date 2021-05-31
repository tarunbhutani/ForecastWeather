import Foundation
import CoreData

final class LocalBookmarkLocationRepository: NSObject {
    
    // MARK: - Initialization
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Private Properties
    
    private let coreDataStack: CoreDataStack
}

extension LocalBookmarkLocationRepository: BookmarkLocationRepository {
    
    func bookmarkLocation(_ location: Location) throws {
        let context = coreDataStack.workerContext
        
        var contextError: Error?
        
        context.performAndWait {
            let mo = LocationManagedObject(context: context)
            mo.id = location.id
            mo.name = location.name
            mo.latitude = location.latitude
            mo.longitude = location.longitude
            
            do {
                try context.save()
            } catch {
                contextError = error
            }
        }
        
        if let error = contextError {
            throw error
        }
    }
    
    func getAllBookmarkLocations() throws -> [Location] {
        var locations: [Location] = []
        var contextError: Error?
        
        let context = coreDataStack.workerContext
        
        context.performAndWait {
            let fetchRequest = NSFetchRequest<LocationManagedObject>(
                entityName: String(describing: LocationManagedObject.self)
            )
            fetchRequest.returnsObjectsAsFaults = false
            do {
                locations = try context.fetch(fetchRequest).map { $0.toDomainModel() }
            } catch {
                contextError = error
            }
        }
        
        if let error = contextError {
            throw error
        }
        
        return locations
    }
    
    func deleteLocation(withId id: String) throws {
        let context = coreDataStack.workerContext
        
        var contextError: Error?
        
        context.performAndWait {
            let fetchRequest = NSFetchRequest<LocationManagedObject>(
                entityName: String(describing: LocationManagedObject.self)
            )
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let result = try context.fetch(fetchRequest).first {
                    context.delete(result)
                }
            } catch {
                contextError = error
            }
        }
        
        if let error = contextError {
            throw error
        }
    }
}
