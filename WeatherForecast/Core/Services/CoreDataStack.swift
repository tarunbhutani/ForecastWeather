import Foundation
import CoreData

/// A class defining and managing the core data stack.
final class CoreDataStack {
    
    // MARK:- Properties
    
    /// Use this property to access managed object context associated with the main queue.
    public lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
        context.shouldDeleteInaccessibleFaults = true
        context.undoManager = nil
        return persistentContainer.viewContext
    }()
    
    /// Creates and configures a private queue context.
    public lazy var workerContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
        return context
    }()
    
    // MARK: - Persistent Container
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: "WeatherForecast"
        )
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                // Crash application if core data stack failed to load.
                fatalError("Failed to load store: \(error!)")
            }
        }
        
        return container
    }()
}
