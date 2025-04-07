import UIKit

/// Presenter responsible for managing the authentication flow and interacting with the interactor and view.
final class AuthPresenter: AuthPresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: AuthViewProtocol?
    var interactor: AuthInteractorProtocol?
    var router: AuthRouterProtocol?
    weak var delegate: AuthModuleDelegate?
    
    // MARK: - AuthPresenterProtocol Methods
    
    /// Called when the view is loaded, can be used for additional setup if needed.
    func viewDidLoad() {
        // Any additional initialization, if required
    }
    
    /// Called when the user taps authenticate (either login or register).
    /// - Parameters:
    ///   - mode: The authentication mode (login or register).
    ///   - name: The user's name (only required for registration).
    ///   - email: The user's email.
    ///   - password: The user's password.
    func didTapAuthenticate(mode: AuthMode, name: String?, email: String, password: String) {
        view?.showLoading()
        switch mode {
        case .login:
            interactor?.login(email: email, password: password)
        case .register:
            interactor?.register(name: name ?? "", email: email, password: password)
        }
    }
}

// MARK: - AuthInteractorOutput

extension AuthPresenter: AuthInteractorOutput {
    
    /// Called when authentication succeeds, passing the user data.
    /// - Parameter user: The authenticated user.
    func authenticationSucceeded(user: UserDTO) {
        view?.hideLoading()
        // Notify the delegate (e.g., profile screen) about successful authentication
        delegate?.authModuleDidAuthenticate()
        // Close the authentication screen
        if let view = view {
            router?.dismissAuthScreen(from: view)
        }
    }
    
    /// Called when authentication fails, passing the error.
    /// - Parameter error: The error that occurred during authentication.
    func authenticationFailed(error: Error) {
        view?.hideLoading()
        
        if let nsError = error as NSError? {
            switch nsError.code {
            case 401:
                view?.showError(message: "Email or password is incorrect. Please try again.")
            case 400:
                view?.showError(message: "User with this email already exists.")
            default:
                view?.showError(message: "Something went wrong. Please check your internet connection and try again.")
            }
        } else {
            view?.showError(message: "Unknown error. Please try again.")
        }
    }
}
