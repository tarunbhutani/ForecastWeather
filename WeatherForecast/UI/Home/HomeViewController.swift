import UIKit
import MapKit

class HomeViewController: UIViewController {

    // MARK: - Section
    
    enum Section: Int, CaseIterable, Hashable {
        case main
    }
    
    // MARK: - Type Aliases
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Location>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Location>
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureCollectionView()
        bindViewModel()
        applySnapshot()
    }
    
    // MARK: - Configure Views
    
    private func configureMapView() {
        mapView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(mapViewDidTap)
        )
        self.mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureCollectionView() {
        // Collection view cells & supplementary views registration.
        collectionView.register(
            UINib(nibName: HomeCollectionCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: HomeCollectionCell.reuseIdentifier
        )
        
        // Configure self-sizing collection view cell.
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.delegate = self
    }
    
    // MARK: - Bind View Model
    
    func bindViewModel() {
        viewModel.bookmarkLocationsDidChangeObservationBlock = { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.applySnapshot()
        }
        
        viewModel.failToBookmarkLocationObservationBlock = { [weak self] error in
            guard let strongSelf = self else { return }
            
            strongSelf.presentFailToBookmarkLocationErrorAlertController()
        }
        
        viewModel.failToBookmarkLocationsObservationBlock = { [weak self] error in
            guard let strongSelf = self else { return }
            
            strongSelf.presentFailToBookmarkLocationsErrorAlertController()
        }
        
        viewModel.failToDeleteBookmarkLocationObservationBlock = { [weak self] error in
            guard let strongSelf = self else { return }
            
            strongSelf.presentFailToDeleteBookmarkLocationsErrorAlertController()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func mapViewDidTap(_ recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // Bookmark Coordinate
        viewModel.bookmarkLocation(
            CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        )
    }
    
    // MARK: - Alert Controllers
    
    private func presentFailToBookmarkLocationErrorAlertController() {
        // TODO: Localize the strings.
        let alertController = UIAlertController(
            title: "Unrecognized Location",
            message: "Location is unrecognized, please select different location.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentFailToBookmarkLocationsErrorAlertController() {
        // TODO: Localize the strings.
        let alertController = UIAlertController(
            title: "Fail to fetch locations",
            message: "An error occurred while fetching the bookmark location, please try again",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentFailToDeleteBookmarkLocationsErrorAlertController() {
        // TODO: Localize the strings.
        let alertController = UIAlertController(
            title: "Fail to delete location",
            message: "An error occurred while deleting the bookmark location, please try again",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - View Model
    
    var viewModel: HomeViewModel!
    
    // MARK: - Private Properties
    
    private lazy var dataSource = createDataSource()
    
    // MARK: - IBOutlets
    
    @IBOutlet private var mapView: MKMapView!
    
    @IBOutlet private var collectionView: UICollectionView!
}

// MARK: - MKMap View Delegate

extension HomeViewController: MKMapViewDelegate {
}

// MARK:- UI collection view data source

extension HomeViewController {
    
    private func applySnapshot(initial: Bool = false) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.bookmarkLocations, toSection: .main)
        
        // Check if collection view is already presenting a set of data. If so, we’d like
        // to animate to the new snapshot of data. If there’s no data visible yet, we want
        // the snapshot to be applied as fast as possible without an animation.
        let shouldAnimate = ((collectionView.dataSource as? DataSource)?.snapshot().numberOfSections) ?? 0 != 0
        
        if snapshot.sectionIdentifiers.count > 0 {
            // Force all items to reload.
            snapshot.reloadSections(snapshot.sectionIdentifiers)
        }
        dataSource.apply(snapshot, animatingDifferences: shouldAnimate)
    }
    
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item -> UICollectionViewCell? in
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionCell.reuseIdentifier,
                    for: indexPath
                ) as! HomeCollectionCell
                
                
                let viewModel: HomeCollectionCellViewModel = HomeCollectionCellViewModel(location: item)
                viewModel.delegate = self
                cell.bindVieModel(viewModel)
                
                return cell
            }
        )
        
        return dataSource
    }
}

// MARK: - UI collection view layout

extension HomeViewController {
    
    /// Provides layout information for a collection view.
    func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100)
            )
            
            let layoutItem = NSCollectionLayoutItem(layoutSize: size)
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [layoutItem])
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            
            return layoutSection
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectBookmarkLocation(at: indexPath.row)
    }
}

// MARK: - Home Collection Cell View Model Delegate

extension HomeViewController: HomeCollectionCellViewModelDelegate {
    
    func deleteLocation(withId id: String) {
        viewModel.deleteLocation(withId: id)
    }
}
