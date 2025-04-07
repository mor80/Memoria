import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: ProfileViewProtocol?
    var interactor: ProfileInteractorProtocol?
    var router: ProfileRouterProtocol?
    
    /// Configuration for the icon images in the profile section.
    let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
    
    // MARK: - ProfilePresenterProtocol
    
    /// Called when the view is loaded, it fetches the user data and displays sections.
    func viewDidLoad() {
        interactor?.fetchUser()
        let icons = [UIImage(systemName: "trophy", withConfiguration: iconConfig), UIImage(systemName: "chart.bar", withConfiguration: iconConfig)]
        view?.displaySections(ProfileSection.allCases, icons)
    }
    
    /// Updates the user's name by calling the interactor.
    /// - Parameter newName: The new name to update.
    func updateUserName(_ newName: String) {
        interactor?.updateUserName(newName)
    }
    
    /// Updates the user's avatar by calling the interactor.
    /// - Parameter newAvatar: The new avatar image to update.
    func updateUserAvatar(_ newAvatar: UIImage) {
        interactor?.updateUserAvatar(newAvatar)
    }
    
    /// Handles section selection by the user.
    /// - Parameter section: The selected profile section.
    func didSelectSection(_ section: ProfileSection) {
        guard let view = view else { return }
        let user = CoreDataManager.shared.fetchUser()
        if user.dto.id.isEmpty {
            router?.navigateToAuth(from: view)
        } else {
            router?.navigateToSection(section, from: view)
        }
    }
    
    /// Handles the tap on the auth button (either login or logout).
    /// - Parameter isLogin: Boolean indicating whether the button is for login or logout.
    func didTapAuthButton(isLogin: Bool) {
        guard let view = view else { return }
        if isLogin {
            router?.navigateToAuth(from: view)
        } else {
            // If logout is selected, perform logout
            interactor?.logoutUser()
        }
    }
}

// MARK: - ProfileInteractorOutput

/// Extension for ProfilePresenter to conform to ProfileInteractorOutputProtocol
/// This handles the response from the interactor (e.g., user data fetch or update).
extension ProfilePresenter: ProfileInteractorOutput {
    
    /// Called when the user data is fetched successfully.
    /// - Parameters:
    ///   - user: The user data retrieved.
    ///   - avatar: The avatar image retrieved.
    func didFetchUser(_ user: UserDTO, avatar: UIImage?) {
        view?.updateUserInfo(with: user, avatar: avatar)
    }
    
    /// Called when the user data is updated successfully.
    /// - Parameters:
    ///   - user: The updated user data.
    ///   - avatar: The updated avatar image.
    func didUpdateUser(_ user: UserDTO, avatar: UIImage?) {
        view?.updateUserInfo(with: user, avatar: avatar)
    }
}
