import UIKit

/// Router responsible for navigating from the Reaction Games module to specific game detail screens.
class ReactionGamesRouter: GameTypeRouterProtocol {
    
    // MARK: - VIPER Reference
    
    /// Reference to the module's view controller.
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    
    /// Creates and returns the Reaction Games module.
    /// - Returns: A `UIViewController` representing the Reaction Games screen.
    static func createModule() -> UIViewController {
        let view = ReactionGamesViewController()
        let presenter = ReactionGamesPresenter()
        let interactor = ReactionGamesInteractor()
        let router = ReactionGamesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    // MARK: - Navigation
    
    /// Navigates to the detail screen of the selected game.
    /// - Parameter gameName: The name of the selected game.
    func navigateToGameDetail(gameName: String) {
        print("Navigating to game: \(gameName)")
        
        switch gameName {
        case "Reaction Time":
            let reactionTime = ReactionTimeRouter.createModule()
            viewController?.navigationController?.pushViewController(reactionTime, animated: true)
            
        case "Quick Math":
            let quickMath = QuickMathRouter.createModule()
            viewController?.navigationController?.pushViewController(quickMath, animated: true)
        
        case "Symbol Sequence":
            let symbolSequence = SymbolSequenceRouter.createModule()
            viewController?.navigationController?.pushViewController(symbolSequence, animated: true)
            
        default:
            break
        }
    }
}
