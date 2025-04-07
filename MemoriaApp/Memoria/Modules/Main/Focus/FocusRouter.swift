import UIKit

/// Router for the Focus Games module.
final class FocusGamesRouter: GameTypeRouterProtocol {
    
    // MARK: - VIPER Reference
    
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    
    /// Creates the Focus Games module and sets up dependencies.
    /// - Returns: A configured `UIViewController` instance.
    static func createModule() -> UIViewController {
        let view = FocusGamesViewController()
        let presenter = FocusGamesPresenter()
        let interactor = FocusGamesInteractor()
        let router = FocusGamesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    // MARK: - Navigation
    
    /// Navigates to the selected game screen.
    /// - Parameter gameName: Name of the selected game.
    func navigateToGameDetail(gameName: String) {
        print("Navigating to game: \(gameName)")
        
        switch gameName {
        case "Stroop Game":
            let stroopGame = StroopGameRouter.createModule()
            viewController?.navigationController?.pushViewController(stroopGame, animated: true)
            
        case "Focus Target":
            let focusTarget = FocusTargetRouter.createModule()
            viewController?.navigationController?.pushViewController(focusTarget, animated: true)
            
        case "Pair Game":
            let pairGame = PairGameRouter.createModule()
            viewController?.navigationController?.pushViewController(pairGame, animated: true)
            
        default:
            break
        }
    }
}
