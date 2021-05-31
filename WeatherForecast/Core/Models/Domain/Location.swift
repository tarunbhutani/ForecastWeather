import Foundation

struct Location: Codable, Hashable {
    
    // MARK: - Properties
    
    let id: String
    
    let name: String
    
    let latitude: Double
    
    let longitude: Double
}
