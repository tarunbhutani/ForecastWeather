import Foundation
import UIKit

/// Coordinator to handle all the logic for presentation between View Controllers.
final class AppCoordinator: NSObject, Coordinator {
    
    // MARK: - Initialization
    
    init(mainViewController: MainViewController, serviceContainer: ServiceContainer) {
        self.mainViewController = mainViewController
        self.serviceContainer = serviceContainer
        
        super.init()
    }
    
    // MARK: - Start Coordinator
    
    func start() {
        // Load main tab view controller.
        let mainTabBarController = StoryboardScene.Main.tabBarController.instantiate()
        mainTabBarController.delegate = self
        
        mainViewController.addChild(mainTabBarController)
        mainViewController.view.addSubview(mainTabBarController.view)
        NSLayoutConstraint.activate(
            mainTabBarController.view.constraints(pinningEdgesTo: mainViewController.view)
        )
        mainTabBarController.didMove(toParent: mainViewController)
        
        // Dashboard coordinator.
        let homeNavigationController = mainTabBarController.viewControllers![0] as! UINavigationController
        let homeViewController = homeNavigationController.topViewController as! HomeViewController
        let homeCoordinator = HomeCoordinator(
            homeViewController: homeViewController,
            serviceContainer: serviceContainer
        )
        self.homeCoordinator = homeCoordinator
        homeCoordinator.start()
        
        // Help Coordinator
        let helpNavigationController = mainTabBarController.viewControllers![1] as! UINavigationController
        let helpViewController = helpNavigationController.topViewController as! HelpViewController
        let helpCoordinator = HelpCoordinator(
            helpViewController: helpViewController,
            serviceContainer: serviceContainer
        )
        self.helpCoordinator = helpCoordinator
    }
    
    // MARK: - View Controllers
    
    // Managed view controllers
    private let mainViewController: MainViewController
    
    // MARK: - Child Coordinators
    
    private var homeCoordinator: HomeCoordinator?
    
    private var helpCoordinator: HelpCoordinator?
    
    // MARK: - Service Container
    
    private let serviceContainer: ServiceContainer
}

extension AppCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
    }
}
