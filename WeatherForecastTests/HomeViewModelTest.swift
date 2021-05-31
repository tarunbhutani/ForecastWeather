import XCTest
import MapKit
@testable import WeatherForecast

class HomeViewModelTest: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
    }
    
    // MARK: - Test Bookmark Positive
    
    func testAddBookmarkLocation_positive() {
        let sut = makeHomeViewModel()
        
        let mockLocation = CLLocation(latitude: 1.2342, longitude: 2.3242)
        
        let addingBookmarkExpectation = expectation(description: "Adding Bookmark")
        sut.bookmarkLocationsDidChangeObservationBlock = {
            XCTAssertEqual(sut.bookmarkLocations.count, 1)
            XCTAssertEqual(sut.bookmarkLocations.last?.latitude, mockLocation.coordinate.latitude)
            XCTAssertEqual(sut.bookmarkLocations.last?.longitude, mockLocation.coordinate.longitude)
            addingBookmarkExpectation.fulfill()
        }
        
        sut.failToBookmarkLocationObservationBlock = { _ in
            XCTFail("Fail to bookmark location")
        }
        
        sut.bookmarkLocation(mockLocation)
        
        wait(for: [addingBookmarkExpectation], timeout: 1)
    }
    
    func testAddBookmarkLocation_negative() {
        let sut = makeHomeViewModel()
        
        let mockLocation = CLLocation(latitude: 0, longitude: 0)
        
        let addingBookmarkExpectation = expectation(description: "Fail to add bookmark")
        sut.bookmarkLocationsDidChangeObservationBlock = {
            XCTFail("SUT should throw error because of invalid location")
        }
        
        sut.failToBookmarkLocationObservationBlock = { _ in
            addingBookmarkExpectation.fulfill()
        }
        
        sut.bookmarkLocation(mockLocation)
        
        wait(for: [addingBookmarkExpectation], timeout: 1)
    }
    
    func testDeleteBookmark_positive() {
        let sut = makeHomeViewModel()
        
        let mockLocation1 = CLLocation(latitude: 1.231, longitude: 2.323)
        sut.bookmarkLocation(mockLocation1)
        
        let executionExpectation = expectation(description: "")
        sut.bookmarkLocationsDidChangeObservationBlock = {
            XCTAssertEqual(sut.bookmarkLocations.count, 1)
            XCTAssertEqual(sut.bookmarkLocations[0].latitude, mockLocation1.coordinate.latitude)
            XCTAssertEqual(sut.bookmarkLocations[0].longitude, mockLocation1.coordinate.longitude)
            executionExpectation.fulfill()
        }
        
        wait(for: [executionExpectation], timeout: 1)
        sut.bookmarkLocationsDidChangeObservationBlock = nil
        sut.deleteLocation(withId: sut.bookmarkLocations[0].id)
        XCTAssertEqual(sut.bookmarkLocations.count, 0)
    }
    
    func testDeleteBookmark_negative() {
        let sut = makeHomeViewModel()
        
        let executionExpectation = expectation(description: "Fail to delete bookmark location")
        sut.failToDeleteBookmarkLocationObservationBlock = { _ in
            executionExpectation.fulfill()
        }
        sut.deleteLocation(withId: "1")
        wait(for: [executionExpectation], timeout: 1)
    }
    
    func testGetBookmarkLocation_positive() {
        let sut = makeHomeViewModel()
        
        let mockLocation1 = CLLocation(latitude: 1.231, longitude: 2.323)
        let mockLocation2 = CLLocation(latitude: 1.331, longitude: 2.623)
        sut.bookmarkLocation(mockLocation1)
        sut.bookmarkLocation(mockLocation2)
        
        sut.getAllBookmarkLocations()
        XCTAssertEqual(sut.bookmarkLocations.count, 2)
    }
    
    func testGetBookmarkLocation_negative() {
        let sut = makeHomeViewModel()
        
        let mockLocation1 = CLLocation(latitude: 1.231, longitude: 2.323)
        let mockLocation2 = CLLocation(latitude: 1.331, longitude: 2.623)
        sut.bookmarkLocation(mockLocation1)
        sut.bookmarkLocation(mockLocation2)
        
        sut.getAllBookmarkLocations()
        XCTAssertNotEqual(sut.bookmarkLocations.count, 1)
    }
    
    // MARK: - Helpers
    
    func makeMockBookmarkLocationService() -> BookmarkLocationService {
        let mockRepository = MockBookmarkLocationRepository()
        return MockBookmarkLocationService(repository: mockRepository)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(bookmarkLocationService: makeMockBookmarkLocationService())
    }
 
    final class MockBookmarkLocationService: NSObject, BookmarkLocationService {
        
        // MARK: - Initialization
        
        init(repository: BookmarkLocationRepository) {
            self.repository = repository
        }
        
        func bookmarkLocation(_ location: CLLocation, completionHandler: @escaping (Result<Location, Error>) -> Void) {
            do {
                let place = Location(
                    id: "1",
                    name: "Test",
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                try repository.bookmarkLocation(place)
                DispatchQueue.main.async {
                    completionHandler(.success(place))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
        
        func getBookmarkLocations() throws -> [Location] {
            do {
                return try repository.getAllBookmarkLocations()
            } catch {
                throw error
            }
        }
        
        func deleteLocation(withId id: String) throws {
            do {
                return try repository.deleteLocation(withId: id)
            } catch {
                throw error
            }
        }
        
        // MARK: - Private Properties
        
        private let repository: BookmarkLocationRepository
    }
    
    final class MockBookmarkLocationRepository: NSObject, BookmarkLocationRepository {
        func bookmarkLocation(_ location: Location) throws {
            if location.latitude == 0 || location.longitude == 0 {
                throw NSError()
            }
            mockLocations.append(location)
        }
        
        func getAllBookmarkLocations() throws -> [Location] {
            return mockLocations
        }
        
        func deleteLocation(withId id: String) throws {
            guard let index = mockLocations.firstIndex(where: { $0.id == id }) else {
                throw NSError()
            }
            mockLocations.remove(at: index)
        }
        
        var mockLocations: [Location] = []
    }
}
