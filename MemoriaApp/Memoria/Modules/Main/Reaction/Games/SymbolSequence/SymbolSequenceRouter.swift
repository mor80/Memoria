import UIKit

/// Router responsible for assembling the Symbol Sequence module.
final class SymbolSequenceRouter: SymbolSequenceRouterProtocol {
    
    // MARK: - Module Creation
    
    /// Creates and returns a fully configured Symbol Sequence module.
    /// - Returns: A `UIViewController` instance representing the game screen.
    static func createModule() -> UIViewController {
        let view = SymbolSequenceViewController()
        let presenter = SymbolSequencePresenter()
        let interactor = SymbolSequenceInteractor()
        let router = SymbolSequenceRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
