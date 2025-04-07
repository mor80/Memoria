import UIKit

/// Router responsible for assembling the Reaction Time module.
final class ReactionTimeRouter: ReactionTimeRouterProtocol {
    
    // MARK: - Module Create
    
    /// Creates and returns a fully configured Reaction Time module.
    /// - Returns: A `UIViewController` instance representing the Reaction Time game.
    static func createModule() -> UIViewController {
        let view = ReactionTimeViewController()
        let presenter = ReactionTimePresenter()
        let interactor = ReactionTimeInteractor()
        let router = ReactionTimeRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
