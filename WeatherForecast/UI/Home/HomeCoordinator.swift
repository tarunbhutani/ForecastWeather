import Foundation

final class HomeCoordinator: NSObject, Coordinator {
    
    // MARK: - Initialization
    
    init(homeViewController: HomeViewController, serviceContainer: ServiceContainer) {
        self.homeViewController = homeViewController
        self.serviceContainer = serviceContainer
    }
    
    // MARK: - Start Flow
    
    func start() {
        let viewModel = HomeViewModel(bookmarkLocationService: serviceContainer.bookmarkLocationServicer)
        viewModel.delegate = self
        homeViewController.viewModel = viewModel
    }
    
    // MARK: - View Controller
    
    private let homeViewController: HomeViewController
    
    // MARK: - Child Coordinators
    
    var cityDetailsCoordinator: CityDetailsCoordinator?
    
    // MARK: - Dependencies
    
    private let serviceContainer: ServiceContainer
}

// MARK: - Home ViewModel Delegate

extension HomeCoordinator: HomeViewModelDelegate {
    
    func homeViewModel(_ viewModel: HomeViewModel, didSelectBookmarkLocation location: Location) {
        cityDetailsCoordinator = nil
        
        let coordinator = CityDetailsCoordinator(
            serviceContainer: serviceContainer,
            location: location,
            presentingViewController: homeViewController
        )
        coordinator.delegate = self
        cityDetailsCoordinator = coordinator
        coordinator.start()
    }
}

// MARK: - City Details Coordinator Delegate

extension HomeCoordinator: CityDetailsCoordinatorDelegate {
    
    func cityDetailsCoordinatorDidFinish(_ coordinator: CityDetailsCoordinator) {
        cityDetailsCoordinator = nil
    }
}
