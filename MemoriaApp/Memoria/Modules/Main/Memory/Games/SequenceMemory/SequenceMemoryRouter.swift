import UIKit

/// Router responsible for assembling the Sequence Memory module and handling navigation.
final class SequenceMemoryRouter: SequenceMemoryRouterProtocol {
    
    // MARK: - Module Creation
    
    /// Creates and returns a fully configured Sequence Memory module.
    /// - Returns: A `UIViewController` representing the game screen.
    static func createModule() -> UIViewController {
        let view = SequenceMemoryViewController()
        let presenter = SequenceMemoryPresenter()
        let interactor = SequenceMemoryInteractor()
        let router = SequenceMemoryRouter()
        
        // VIPER connections
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
