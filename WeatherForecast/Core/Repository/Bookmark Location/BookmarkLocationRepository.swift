import Foundation

protocol BookmarkLocationRepository: NSObjectProtocol {
    
    func bookmarkLocation(_ location: Location) throws
    
    func getAllBookmarkLocations() throws -> [Location]
    
    func deleteLocation(withId id: String) throws
}
