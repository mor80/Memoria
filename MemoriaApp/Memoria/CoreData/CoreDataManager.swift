import CoreData
import UIKit

/// A singleton manager for handling Core Data operations.
final class CoreDataManager {
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()
    
    // MARK: - Properties
    
    let persistentContainer: NSPersistentContainer
    
    /// The main context for performing operations on the main thread.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Initialization
    
    /// Initializes the Core Data stack with container named "Memoria".
    private init() {
        persistentContainer = NSPersistentContainer(name: "Memoria")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error)")
            }
        }
    }
    
    // MARK: - Saving
    
    /// Saves changes in the context if there are any.
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data context: \(error)")
        }
    }
    
    // MARK: - User Handling
    
    /// Updates an existing user or creates a new one.
    /// - Parameter dto: A user data transfer object.
    func updateOrCreateUserEntity(from dto: UserDTO) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        if let user = (try? context.fetch(fetchRequest))?.first {
            user.id = dto.id
            user.name = dto.name
            user.email = dto.email
            user.experience = Int32(dto.experience)
            user.isLoggedIn = true
        } else {
            let newUser = UserEntity(context: context)
            newUser.id = dto.id
            newUser.name = dto.name
            newUser.email = dto.email
            newUser.experience = Int32(dto.experience)
            newUser.isLoggedIn = true
            newUser.avatar = nil
        }
        
        try? context.save()
    }
    
    /// Fetches the user entity from storage.
    /// - Returns: The first found `UserEntity`, or `nil` if none exists.
    func fetchUserEntity() -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }
    
    /// Retrieves the user DTO and avatar.
    /// - Returns: A tuple containing the `UserDTO` and optional `UIImage`.
    func fetchUser() -> (dto: UserDTO, avatar: UIImage?) {
        if let userEntity = fetchUserEntity() {
            return convertToUserDTO(from: userEntity)
        } else {
            let defaultUserDTO = UserDTO(
                id: "",
                name: "User Name",
                experience: 1000,
                email: "",
                avatarUrl: nil
            )
            updateOrCreateUserEntity(from: defaultUserDTO)
            return (defaultUserDTO, nil)
        }
    }
    
    /// Updates the user's name.
    /// - Parameter newName: The new name string.
    /// - Returns: A tuple with the updated `UserDTO` and optional avatar, or `nil` on failure.
    func updateUserName(_ newName: String) -> (dto: UserDTO, avatar: UIImage?)? {
        guard let userEntity = fetchUserEntity() else { return nil }
        userEntity.name = newName
        do {
            try context.save()
            return convertToUserDTO(from: userEntity)
        } catch {
            print("Failed to update user name: \(error)")
            return nil
        }
    }
    
    /// Updates the user's avatar image.
    /// - Parameter newAvatar: The new avatar image.
    /// - Returns: A tuple with the updated `UserDTO` and avatar, or `nil` on failure.
    func updateUserAvatar(_ newAvatar: UIImage) -> (dto: UserDTO, avatar: UIImage?)? {
        guard let userEntity = fetchUserEntity() else { return nil }
        if let imageData = newAvatar.jpegData(compressionQuality: 1) {
            userEntity.avatar = imageData
            do {
                try context.save()
                return convertToUserDTO(from: userEntity)
            } catch {
                print("Failed to update user avatar: \(error)")
                return nil
            }
        }
        return nil
    }
    
    /// Logs out the user and clears credentials.
    func logoutUser() {
        if let user = fetchUserEntity() {
            user.id = ""
            user.email = ""
            user.isLoggedIn = false
        }
        clearToken()
        try? context.save()
    }
    
    /// Converts a `UserEntity` into a `UserDTO` with an optional avatar image.
    /// - Parameter entity: The Core Data user entity.
    /// - Returns: A tuple of `UserDTO` and optional `UIImage`.
    private func convertToUserDTO(from entity: UserEntity) -> (dto: UserDTO, avatar: UIImage?) {
        let avatarImage: UIImage? = {
            if let data = entity.avatar {
                return UIImage(data: data)
            }
            return nil
        }()
        
        let dto = UserDTO(
            id: entity.id ?? "",
            name: entity.name ?? "User Name",
            experience: Int(entity.experience),
            email: entity.email ?? "",
            avatarUrl: nil
        )
        
        return (dto, avatarImage)
    }
    
    // MARK: - Token Handling
    
    /// Updates or creates a token entity.
    /// - Parameter tokenDTO: The token data transfer object.
    func updateOrCreateTokenEntity(from tokenDTO: TokenDTO) {
        let fetchRequest: NSFetchRequest<TokenEntity> = TokenEntity.fetchRequest()
        
        if let results = try? context.fetch(fetchRequest),
           let tokenEntity = results.first {
            tokenEntity.accessToken = tokenDTO.accessToken
            tokenEntity.tokenType = tokenDTO.tokenType
        } else {
            let tokenEntity = TokenEntity(context: context)
            tokenEntity.accessToken = tokenDTO.accessToken
            tokenEntity.tokenType = tokenDTO.tokenType
        }
        
        saveContext()
    }
    
    /// Retrieves the access token string from storage.
    /// - Returns: The access token as a `String`, or `nil` if not found.
    func getToken() -> String? {
        let fetchRequest: NSFetchRequest<TokenEntity> = TokenEntity.fetchRequest()
        if let results = try? context.fetch(fetchRequest),
           let tokenEntity = results.first {
            return tokenEntity.accessToken
        }
        return nil
    }
    
    /// Deletes all stored token entities.
    func clearToken() {
        let fetchRequest: NSFetchRequest<TokenEntity> = TokenEntity.fetchRequest()
        if let results = try? context.fetch(fetchRequest) {
            results.forEach { context.delete($0) }
        }
        saveContext()
    }
}
