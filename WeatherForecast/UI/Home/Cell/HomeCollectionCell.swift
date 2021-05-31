import UIKit

class HomeCollectionCell: UICollectionViewCell, NibReusable {

    // MARK: - Awake From Nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Bind View Model
    
    func bindVieModel(_ viewModel: HomeCollectionCellViewModel) {
        self.viewModel = viewModel
        
        name.text = viewModel.name
        coordinateLabel.text = viewModel.coordinates
    }
    
    // MARK: - Actions
    
    @IBAction private func deleteButtonDidTap(_ sender: UIButton) {
        viewModel.deleteLocation()
    }
    
    // MARK: - View Model
    
    private var viewModel: HomeCollectionCellViewModel!
    
    // MARK: - IBOutlets
    
    @IBOutlet private var name: UILabel!
    
    @IBOutlet private var coordinateLabel: UILabel!
}
