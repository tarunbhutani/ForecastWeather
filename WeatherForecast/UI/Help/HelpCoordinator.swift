import Foundation

final class HelpCoordinator: NSObject, Coordinator {
    
    // MARK: - Initialization
    
    init(helpViewController: HelpViewController, serviceContainer: ServiceContainer) {
        self.helpViewController = helpViewController
        self.serviceContainer = serviceContainer
    }
    
    // MARK: - Start Flow
    
    func start() {
        
    }
    
    // MARK: - View Controller
    
    private let helpViewController: HelpViewController
    
    // MARK: - Dependencies
    
    private let serviceContainer: ServiceContainer
}
