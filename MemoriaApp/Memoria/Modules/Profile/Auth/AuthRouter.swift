import UIKit

/// Router responsible for handling navigation and module creation in the Auth module.
class AuthRouter: AuthRouterProtocol {
    
    // MARK: - Properties
    
    /// Delegate to handle post-authentication actions.
    weak var delegate: AuthModuleDelegate?
    
    // MARK: - AuthRouterProtocol Methods
    
    /// Creates and returns the view controller for the Auth module.
    /// - Parameter delegate: The delegate to handle authentication success. Default is nil.
    /// - Returns: A `UIViewController` instance for the Auth module.
    static func createModule(delegate: AuthModuleDelegate? = nil) -> UIViewController {
        let view = AuthViewController()
        let presenter = AuthPresenter()
        let interactor = AuthInteractor()
        let router = AuthRouter()
        router.delegate = delegate
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.delegate = delegate
        interactor.presenter = presenter
        
        return view
    }
    
    /// Dismisses the authentication screen.
    /// - Parameter view: The `AuthViewProtocol` view to dismiss.
    func dismissAuthScreen(from view: AuthViewProtocol) {
        if let viewController = view as? UIViewController {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
