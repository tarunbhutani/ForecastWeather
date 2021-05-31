import Foundation
import UIKit

extension UIView {
    
    public func constraints(pinningEdgesTo view: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor) ]
        return constraints
    }
    
    func usesAutolayout(_ usesAutolayout: Bool) {
        translatesAutoresizingMaskIntoConstraints = !usesAutolayout
    }
}
