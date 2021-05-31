import Foundation
import UIKit

// MARK: - Implementation Details

protocol StoryboardType {
    static var storyboardName: String { get }
}

extension StoryboardType {
    static var storyboard: UIStoryboard {
        let name = self.storyboardName
        return UIStoryboard(name: name, bundle: nil)
    }
}

enum StoryboardScene {
    enum Main: StoryboardType {
        static let storyboardName = "Main"
        
        static let initialScene = InitialSceneType<MainViewController>(storyboard: Main.self)
        
        static let tabBarController = SceneType<UIKit.UITabBarController>(storyboard: Main.self, identifier: "TabBarController")
    }
}

struct SceneType<T: UIViewController> {
    let storyboard: StoryboardType.Type
    let identifier: String
    
    func instantiate() -> T {
        let identifier = self.identifier
        guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
        }
        return controller
    }
    
    @available(iOS 13.0, tvOS 13.0, *)
    func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
        return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
    }
}

struct InitialSceneType<T: UIViewController> {
    let storyboard: StoryboardType.Type
    
    func instantiate() -> T {
        guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
            fatalError("ViewController is not of the expected class \(T.self).")
        }
        return controller
    }
    
    @available(iOS 13.0, tvOS 13.0, *)
    func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
        guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
            fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
        }
        return controller
    }
}
