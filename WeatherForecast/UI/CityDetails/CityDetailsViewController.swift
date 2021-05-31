import UIKit

final class CityDetailsViewController: UIViewController {

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        updateViews()
    }
    
    // MARK: - Deinitialize
    
    deinit {
        print("City Details ViewController Deinitialize")
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        viewModel.presentationStateDidChangeObservationBlock = { [self] state in
            switch state {
            case .loading:
                activityIndicatorView.startAnimating()
                
            case .loaded:
                activityIndicatorView.stopAnimating()
                updateViews()
                
            case .loadingFailed:
                activityIndicatorView.stopAnimating()
                presentErrorAlertController()
            }
        }
    }
    
    // MARK: - Update View Model
    
    private func updateViews() {
        guard case .loaded(let presentation) = viewModel.presentationState else { return }
        
        cityNameLabel.text = presentation.name
        temperatureLabel.text = presentation.temperature
        humidityLabel.text = presentation.humidity
    }
    
    // MARK: - Alert Controller
    
    private func presentErrorAlertController() {
        let alertController = UIAlertController(
            title: "Failed to fetch location",
            message: "An error occurred while fetching weather forecast, please try again.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - View Model
    
    var viewModel: CityDetailsViewModel!
    
    // MARK: - Outlets
    
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private var cityNameLabel: UILabel!
    
    @IBOutlet private var temperatureLabel: UILabel!
    
    @IBOutlet private var humidityLabel: UILabel!
}
