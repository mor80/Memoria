import UIKit

// MARK: - View
/// Protocol defining the view's responsibilities in the Auth module.
protocol AuthViewProtocol: AnyObject {
    /// Shows a loading indicator.
    func showLoading()
    
    /// Hides the loading indicator.
    func hideLoading()
    
    /// Displays an error message.
    /// - Parameter message: The error message to be displayed.
    func showError(message: String)
}

// MARK: - Presenter
/// Protocol defining the presenter's responsibilities in the Auth module.
protocol AuthPresenterProtocol: AnyObject {
    var view: AuthViewProtocol? { get set }
    var interactor: AuthInteractorProtocol? { get set }
    var router: AuthRouterProtocol? { get set }
    var delegate: AuthModuleDelegate? { get set }
    
    /// Called when the view is loaded.
    func viewDidLoad()
    
    /// Called when the authenticate button is tapped (login or register).
    /// - Parameters:
    ///   - mode: The authentication mode (login or register).
    ///   - name: The user's name (required for registration).
    ///   - email: The user's email.
    ///   - password: The user's password.
    func didTapAuthenticate(mode: AuthMode, name: String?, email: String, password: String)
}

// MARK: - Interactor
/// Protocol defining the interactor's responsibilities in the Auth module.
protocol AuthInteractorProtocol: AnyObject {
    var presenter: AuthInteractorOutput? { get set }
    
    /// Authenticates the user via login.
    /// - Parameters:
    ///   - email: The user's email.
    ///   - password: The user's password.
    func login(email: String, password: String)
    
    /// Registers a new user.
    /// - Parameters:
    ///   - name: The user's name.
    ///   - email: The user's email.
    ///   - password: The user's password.
    func register(name: String, email: String, password: String)
}

/// Protocol defining the interactor's output responsibilities.
protocol AuthInteractorOutput: AnyObject {
    /// Called when authentication is successful.
    /// - Parameter user: The authenticated user's data.
    func authenticationSucceeded(user: UserDTO)
    
    /// Called when authentication fails.
    /// - Parameter error: The error that occurred during authentication.
    func authenticationFailed(error: Error)
}

// MARK: - Router
/// Protocol defining the router's responsibilities in the Auth module.
protocol AuthRouterProtocol: AnyObject {
    /// Creates and returns the Auth module's view controller.
    /// - Parameter delegate: The delegate to handle authentication success.
    /// - Returns: A `UIViewController` instance for the Auth module.
    static func createModule(delegate: AuthModuleDelegate?) -> UIViewController
    
    /// Dismisses the authentication screen.
    /// - Parameter view: The `AuthViewProtocol` view to dismiss.
    func dismissAuthScreen(from view: AuthViewProtocol)
}

// MARK: - Delegate
/// Protocol defining the responsibilities of the Auth module delegate.
protocol AuthModuleDelegate: AnyObject {
    /// Called when the authentication process is successful.
    func authModuleDidAuthenticate()
}
