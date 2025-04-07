import UIKit

// MARK: - View

/// Protocol defining the responsibilities of the view in the Profile module.
protocol ProfileViewProtocol: AnyObject {
    /// Updates the UI with the user's information and avatar.
    /// - Parameters:
    ///   - user: The user data to be displayed.
    ///   - avatar: The avatar image to be displayed.
    func updateUserInfo(with user: UserDTO, avatar: UIImage?)
    
    /// Displays the profile section buttons.
    /// - Parameters:
    ///   - sections: The list of sections to be displayed.
    ///   - icons: The icons associated with each section.
    func displaySections(_ sections: [ProfileSection], _ icons: [UIImage?])
}

// MARK: - Presenter

/// Protocol defining the responsibilities of the presenter in the Profile module.
protocol ProfilePresenterProtocol: AnyObject {
    /// Reference to the view in the Profile module.
    var view: ProfileViewProtocol? { get set }
    
    /// Reference to the interactor in the Profile module.
    var interactor: ProfileInteractorProtocol? { get set }
    
    /// Reference to the router in the Profile module.
    var router: ProfileRouterProtocol? { get set }
    
    /// Called when the view is loaded, triggers user data fetching and section display.
    func viewDidLoad()
    
    /// Updates the user's name.
    /// - Parameter newName: The new name to update.
    func updateUserName(_ newName: String)
    
    /// Updates the user's avatar.
    /// - Parameter newAvatar: The new avatar image to set.
    func updateUserAvatar(_ newAvatar: UIImage)
    
    /// Handles the selection of a profile section.
    /// - Parameter section: The selected profile section.
    func didSelectSection(_ section: ProfileSection)
    
    /// Handles the tap on the authentication button (either login or logout).
    /// - Parameter isLogin: A boolean indicating whether the button is for login or logout.
    func didTapAuthButton(isLogin: Bool)
}

// MARK: - Interactor

/// Protocol defining the responsibilities of the interactor in the Profile module.
protocol ProfileInteractorProtocol: AnyObject {
    /// Reference to the interactor's output.
    var presenter: ProfileInteractorOutput? { get set }
    
    /// Fetches the user's profile data from the local storage.
    func fetchUser()
    
    /// Updates the user's name.
    /// - Parameter newName: The new name to update.
    func updateUserName(_ newName: String)
    
    /// Updates the user's avatar.
    /// - Parameter newAvatar: The new avatar image to set.
    func updateUserAvatar(_ newAvatar: UIImage)
    
    /// Logs the user out.
    func logoutUser()  // New method for logging the user out
}

/// Protocol defining the output responsibilities of the interactor.
protocol ProfileInteractorOutput: AnyObject {
    /// Called when the user's data is successfully fetched.
    /// - Parameters:
    ///   - user: The user data fetched.
    ///   - avatar: The user's avatar.
    func didFetchUser(_ user: UserDTO, avatar: UIImage?)
    
    /// Called when the user's data is successfully updated.
    /// - Parameters:
    ///   - user: The updated user data.
    ///   - avatar: The updated avatar.
    func didUpdateUser(_ user: UserDTO, avatar: UIImage?)
}

// MARK: - Router

/// Protocol defining the responsibilities of the router in the Profile module.
protocol ProfileRouterProtocol: AnyObject {
    /// Creates and returns the complete Profile module (view + VIPER stack).
    /// - Returns: A `UIViewController` instance representing the Profile module.
    static func createModule() -> UIViewController
    
    /// Navigates to a specific section of the profile.
    /// - Parameters:
    ///   - section: The section to navigate to.
    ///   - view: The view from which to navigate.
    func navigateToSection(_ section: ProfileSection, from view: ProfileViewProtocol)
    
    /// Navigates to the authentication screen (for login or logout).
    /// - Parameters:
    ///   - view: The view from which to navigate.
    func navigateToAuth(from view: ProfileViewProtocol)
}
