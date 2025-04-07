import UIKit

final class ProfileInteractor: ProfileInteractorProtocol {
    
    // MARK: - VIPER References
    
    weak var presenter: ProfileInteractorOutput?
    
    /// Service used to handle user-related network operations.
    private let userService: UserService
    
    // MARK: - Initialization
    
    /// Initializes the ProfileInteractor with a given user service.
    /// - Parameter userService: The service used to handle user operations (default is a new instance of `UserService`).
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    // MARK: - Profile Fetch and Update
    
    /// Fetches the user's profile data from the local storage (CoreData).
    func fetchUser() {
        let result = CoreDataManager.shared.fetchUser()
        presenter?.didFetchUser(result.dto, avatar: result.avatar)
    }
    
    /// Updates the user's name both locally and on the server.
    /// - Parameter newName: The new name for the user.
    func updateUserName(_ newName: String) {
        // First, update locally
        guard let localResult = CoreDataManager.shared.updateUserName(newName) else {
            print("Ошибка локального обновления имени")
            return
        }
        presenter?.didUpdateUser(localResult.dto, avatar: localResult.avatar)
        
        // If the user is logged in, send the update to the server
        if !localResult.dto.id.isEmpty {
            userService.updateUser(with: localResult.dto.id,
                                   updateData: UpdateUserDTO(name: newName, email: nil, experience: nil)) { [weak self] updateResult in
                DispatchQueue.main.async {
                    switch updateResult {
                    case .success(_):
                        // Re-fetch local data to synchronize with the server
                        let newLocalResult = CoreDataManager.shared.fetchUser()
                        self?.presenter?.didUpdateUser(newLocalResult.dto, avatar: newLocalResult.avatar)
                    case .failure(let error):
                        print("Ошибка обновления имени на сервере: \(error)")
                    }
                }
            }
        }
    }
    
    /// Updates the user's avatar both locally and on the server.
    /// - Parameter newAvatar: The new avatar image to set for the user.
    func updateUserAvatar(_ newAvatar: UIImage) {
        // First, update locally
        guard let localResult = CoreDataManager.shared.updateUserAvatar(newAvatar) else {
            print("Ошибка локального обновления аватара")
            return
        }
        presenter?.didUpdateUser(localResult.dto, avatar: localResult.avatar)
        
        // If the user is logged in, upload the new avatar to the server
        if !localResult.dto.id.isEmpty {
            userService.uploadAvatar(for: localResult.dto.id,
                                     image: newAvatar,
                                     fileName: "avatar.jpg") { [weak self] uploadResult in
                DispatchQueue.main.async {
                    switch uploadResult {
                    case .success(_):
                        let newLocalResult = CoreDataManager.shared.fetchUser()
                        self?.presenter?.didUpdateUser(newLocalResult.dto, avatar: newLocalResult.avatar)
                    case .failure(let error):
                        print("Ошибка загрузки аватара на сервер: \(error)")
                    }
                }
            }
        }
    }
    
    /// Logs the user out and updates their data in the local storage.
    func logoutUser() {
        CoreDataManager.shared.logoutUser()
        let result = CoreDataManager.shared.fetchUser()
        presenter?.didUpdateUser(result.dto, avatar: result.avatar)
    }
}
