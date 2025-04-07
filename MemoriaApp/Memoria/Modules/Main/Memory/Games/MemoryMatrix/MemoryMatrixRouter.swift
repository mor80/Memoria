import UIKit

/// Router responsible for creating and assembling the Memory Matrix module.
final class MemoryMatrixRouter: MemoryMatrixRouterProtocol {
    
    // MARK: - Module Creation
    
    /// Creates and returns a fully configured Memory Matrix module.
    /// - Returns: A `UIViewController` instance representing the game screen.
    static func createModule() -> UIViewController {
        let view = MemoryMatrixViewController()
        let presenter = MemoryMatrixPresenter()
        let interactor = MemoryMatrixInteractor()
        let router = MemoryMatrixRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
