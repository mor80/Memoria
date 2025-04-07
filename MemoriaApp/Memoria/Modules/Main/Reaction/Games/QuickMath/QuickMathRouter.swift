import UIKit

/// Router responsible for assembling the Quick Math module.
final class QuickMathRouter: QuickMathRouterProtocol {
    
    // MARK: - Module Creation
    
    /// Creates and returns a fully configured Quick Math module.
    /// - Returns: A `UIViewController` instance representing the Quick Math game.
    static func createModule() -> UIViewController {
        let view = QuickMathViewController()
        let presenter = QuickMathPresenter()
        let interactor = QuickMathInteractor()
        let router = QuickMathRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
