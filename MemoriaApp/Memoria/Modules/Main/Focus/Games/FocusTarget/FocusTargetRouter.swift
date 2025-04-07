import UIKit

/// Router responsible for assembling the Focus Target module.
class FocusTargetRouter: FocusTargetRouterProtocol {
    
    /// Creates and returns a configured instance of `FocusTargetViewController`.
    /// - Returns: A `UIViewController` with all VIPER components wired together.
    static func createModule() -> UIViewController {
        let view = FocusTargetViewController()
        let presenter = FocusTargetPresenter()
        let interactor = FocusTargetInteractor()
        let router = FocusTargetRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
