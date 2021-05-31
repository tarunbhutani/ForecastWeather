import Foundation
import UIKit

protocol CityDetailsCoordinatorDelegate: NSObjectProtocol {
    
    func cityDetailsCoordinatorDidFinish(_ coordinator: CityDetailsCoordinator)
}

final class CityDetailsCoordinator: NSObject, Coordinator {
    
    // MARK: - Initialization
    
    init(serviceContainer: ServiceContainer, location: Location, presentingViewController: UIViewController) {
        self.serviceContainer = serviceContainer
        self.location = location
        self.presentingViewController = presentingViewController
    }
    
    // MARK: - Start Flow
    
    func start() {
        let configuration = CityDetailsBuilder.BuilderConfiguration(
            serviceContainer: serviceContainer,
            location: location
        )
        let viewController = CityDetailsBuilder.build(configuration)
        self.cityDetailsViewController = viewController
        presentingViewController.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Delegate
    
    weak var delegate: CityDetailsCoordinatorDelegate?
    
    // MARK: - View Controllers
    
    weak var cityDetailsViewController: CityDetailsViewController?
    
    // MARK: - Dependencies
    
    let serviceContainer: ServiceContainer
    
    let location: Location
    
    private let presentingViewController: UIViewController
}
