import UIKit

/// Router for the Stroop Game module.
class StroopGameRouter: StroopGameRouterProtocol {
    
    // MARK: - Module Creation
    
    /// Creates and connects all components of the Stroop Game module.
    /// - Returns: A fully configured `UIViewController` for the Stroop Game.
    static func createModule() -> UIViewController {
        let view = StroopGameViewController()
        let presenter = StroopGamePresenter()
        let interactor = StroopGameInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
