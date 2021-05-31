import Foundation
import UIKit

struct CityDetailsBuilder {

    struct BuilderConfiguration {
        // MARK: - Initialization
        
        init(serviceContainer: ServiceContainer, location: Location) {
            self.serviceContainer = serviceContainer
            self.location = location
        }
        
        let location: Location
        let serviceContainer: ServiceContainer
    }

    static func build(_ builder: BuilderConfiguration) -> CityDetailsViewController {
        // TODO: Use SwiftGEN to make storyboard name more type safe.
        let viewController = UIStoryboard(
            name: "CityDetails",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: String(describing: CityDetailsViewController.self)
        ) as! CityDetailsViewController
        
        let viewModel = CityDetailsViewModel(
            weatherService: builder.serviceContainer.weatherService,
            location: builder.location
        )
        viewController.viewModel = viewModel
        
        return viewController
    }
}
