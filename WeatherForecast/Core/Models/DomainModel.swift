import Foundation

protocol DomainModel {
    associatedtype DomainModelType
    
    func toDomainModel() -> DomainModelType
}
