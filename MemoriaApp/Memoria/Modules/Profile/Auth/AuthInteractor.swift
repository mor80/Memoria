import Foundation
import UIKit

/// Interactor responsible for handling authentication-related actions.
final class AuthInteractor: AuthInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    /// Reference to the presenter for passing data.
    weak var presenter: AuthInteractorOutput?
    
    // MARK: - Services
    
    private let userService: UserService
    
    // MARK: - Initialization
    
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    // MARK: - AuthInteractorProtocol Methods
    
    /// Handles user login by verifying credentials.
    /// - Parameters:
    ///   - email: The user's email.
    ///   - password: The user's password.
    func login(email: String, password: String) {
        userService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    // If user has an avatarUrl, download the avatar
                    if let avatarUrl = user.avatarUrl, !avatarUrl.isEmpty {
                        self?.userService.downloadAvatar(for: user) { downloadResult in
                            DispatchQueue.main.async {
                                switch downloadResult {
                                case .success(let imageData):
                                    if let image = UIImage(data: imageData) {
                                        // Update avatar locally
                                        if let _ = CoreDataManager.shared.updateUserAvatar(image) {
                                            // After updating local data, send updated user to Presenter
                                            let updatedUser = CoreDataManager.shared.fetchUser().dto
                                            self?.presenter?.authenticationSucceeded(user: updatedUser)
                                        } else {
                                            self?.presenter?.authenticationSucceeded(user: user)
                                        }
                                    } else {
                                        self?.presenter?.authenticationSucceeded(user: user)
                                    }
                                case .failure(let error):
                                    print("Error downloading avatar: \(error)")
                                    self?.presenter?.authenticationSucceeded(user: user)
                                }
                            }
                        }
                    } else {
                        self?.presenter?.authenticationSucceeded(user: user)
                    }
                case .failure(let error):
                    self?.presenter?.authenticationFailed(error: error)
                }
            }
        }
    }
    
    /// Registers a new user with the provided credentials.
    /// - Parameters:
    ///   - name: The user's name.
    ///   - email: The user's email.
    ///   - password: The user's password.
    func register(name: String, email: String, password: String) {
        userService.register(name: name, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    // Check if there's a locally selected avatar
                    let localAvatar = CoreDataManager.shared.fetchUser().avatar
                    if let avatarImage = localAvatar {
                        self?.userService.uploadAvatar(for: user.id, image: avatarImage, fileName: "avatar.jpg") { uploadResult in
                            DispatchQueue.main.async {
                                switch uploadResult {
                                case .success(let updatedUser):
                                    // After successfully uploading avatar, update local data
                                    let updatedLocal = CoreDataManager.shared.fetchUser().dto
                                    self?.presenter?.authenticationSucceeded(user: updatedLocal)
                                case .failure(let error):
                                    print("Error uploading avatar during registration: \(error)")
                                    self?.presenter?.authenticationSucceeded(user: user)
                                }
                            }
                        }
                    } else {
                        self?.presenter?.authenticationSucceeded(user: user)
                    }
                case .failure(let error):
                    self?.presenter?.authenticationFailed(error: error)
                }
            }
        }
    }
}
