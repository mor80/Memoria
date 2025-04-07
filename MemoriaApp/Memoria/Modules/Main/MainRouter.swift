import UIKit

/// Router responsible for navigating between game types in the Main module.
class MainRouter: MainRouterProtocol {
    
    // MARK: - VIPER Reference
    
    /// Reference to the view controller to perform navigation.
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    
    /// Creates and returns the main module view controller.
    /// - Returns: A `UIViewController` for the Main module.
    static func createModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let router = MainRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    // MARK: - Navigation
    
    /// Navigates to the selected game type screen.
    /// - Parameter type: The name of the selected game type.
    func navigateToGameType(_ type: String) {
        print("Navigating to \(type)")
        
        switch type {
        case "Memory":
            let memoryGamesModule = MemoryGamesRouter.createModule()
            viewController?.navigationController?.pushViewController(memoryGamesModule, animated: true)
            
        case "Focus":
            let focusGamesModule = FocusGamesRouter.createModule()
            viewController?.navigationController?.pushViewController(focusGamesModule, animated: true)
            
        case "Reaction":
            let reactionGamesModule = ReactionGamesRouter.createModule()
            viewController?.navigationController?.pushViewController(reactionGamesModule, animated: true)
            
        default:
            break
        }
    }
}
