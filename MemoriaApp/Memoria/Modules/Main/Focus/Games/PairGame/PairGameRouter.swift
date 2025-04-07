import UIKit

/// Router responsible for assembling the Pair Game module.
final class PairGameRouter: PairGameRouterProtocol {
    
    /// Creates and returns a fully configured Pair Game module.
    /// - Returns: A `UIViewController` instance with all VIPER components connected.
    static func createModule() -> UIViewController {
        let view = PairGameViewController()
        let presenter = PairGamePresenter()
        let interactor = PairGameInteractor()
        let router = PairGameRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
