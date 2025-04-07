import Foundation
import UIKit

// MARK: - UserService

/// Service responsible for handling user-related network operations.
final class UserService {
    
    private let networkWorker: NetworkingLogic
    private let baseURL: String
    
    // MARK: - Initialization
    
    /// Initializes the UserService with an optional base URL.
    /// - Parameter baseURL: The base URL for the API (default is shared constant).
    init(baseURL: String = SharedConsts.baseURL) {
        self.baseURL = baseURL
        self.networkWorker = BaseURLWorker(baseURL: baseURL)
    }
    
    // MARK: - Login
    
    /// Authenticates the user with their email and password (POST request).
    /// - Parameters:
    ///   - email: The email of the user.
    ///   - password: The password of the user.
    ///   - completion: Completion handler that returns the user data or an error.
    func login(email: String, password: String, completion: @escaping (Result<UserDTO, Error>) -> Void) {
        let loginDTO = LoginDTO(email: email, password: password)
        let bodyData = loginDTO.generateRequestBody()
        let request = Request(endpoint: UserEndpoint.login,
                              method: .post,
                              paremetrs: nil,
                              body: bodyData)
        
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(let serverResponse):
                if let httpResponse = serverResponse.response as? HTTPURLResponse,
                   httpResponse.statusCode == 401 {
                    // If status code is 401, return a custom error
                    let nsError = NSError(domain: "AuthErrorDomain", code: 401,
                                          userInfo: [NSLocalizedDescriptionKey: "Email or password is incorrect. Please try again."]
                    )
                    completion(.failure(nsError))
                    return
                }
                
                guard let data = serverResponse.data else {
                    completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let tokenDTO = try JSONDecoder().decode(TokenDTO.self, from: data)
                    CoreDataManager.shared.updateOrCreateTokenEntity(from: tokenDTO)
                    CoreDataManager.shared.updateOrCreateUserEntity(from: tokenDTO.user)
                    completion(.success(tokenDTO.user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Registration
    
    /// Registers a new user with name, email, and password (POST request).
    /// - Parameters:
    ///   - name: The name of the user.
    ///   - email: The email of the user.
    ///   - password: The password of the user.
    ///   - completion: Completion handler that returns the user data or an error.
    func register(name: String, email: String, password: String, completion: @escaping (Result<UserDTO, Error>) -> Void) {
        let addUserDTO = AddUserDTO(name: name, email: email, password: password)
        guard let bodyData = try? JSONEncoder().encode(addUserDTO) else {
            completion(.failure(NSError(domain: "EncodingError", code: -1, userInfo: nil)))
            return
        }
        let request = Request(endpoint: UserEndpoint.register,
                              method: .post,
                              paremetrs: nil,
                              body: bodyData)
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(let serverResponse):
                if let httpResponse = serverResponse.response as? HTTPURLResponse,
                   httpResponse.statusCode == 400 {
                    // If status code is 400, return a custom error
                    let nsError = NSError(domain: "AuthErrorDomain", code: 400,
                                          userInfo: [NSLocalizedDescriptionKey: "User with this email already exists."]
                    )
                    completion(.failure(nsError))
                    return
                }
                
                guard let data = serverResponse.data else {
                    completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let tokenDTO = try JSONDecoder().decode(TokenDTO.self, from: data)
                    CoreDataManager.shared.updateOrCreateTokenEntity(from: tokenDTO)
                    CoreDataManager.shared.updateOrCreateUserEntity(from: tokenDTO.user)
                    completion(.success(tokenDTO.user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Get User by ID
    
    /// Fetches a user by their ID (GET request).
    /// - Parameters:
    ///   - id: The ID of the user to fetch.
    ///   - completion: Completion handler that returns the user data or an error.
    func getUser(by id: String, completion: @escaping (Result<UserDTO, Error>) -> Void) {
        let request = Request(endpoint: UserEndpoint.getUserById(id),
                              method: .get,
                              paremetrs: nil,
                              body: nil)
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(let serverResponse):
                guard let data = serverResponse.data else {
                    completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let user = try JSONDecoder().decode(UserDTO.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update User
    
    /// Updates the user with new data (PATCH request).
    /// - Parameters:
    ///   - id: The ID of the user to update.
    ///   - updateData: The updated user data.
    ///   - completion: Completion handler that returns the updated user data or an error.
    func updateUser(with id: String, updateData: UpdateUserDTO, completion: @escaping (Result<UserDTO, Error>) -> Void) {
        guard let bodyData = try? JSONEncoder().encode(updateData) else {
            completion(.failure(NSError(domain: "EncodingError", code: -1, userInfo: nil)))
            return
        }
        let request = Request(endpoint: UserEndpoint.updateUser(id),
                              method: .patch,
                              paremetrs: nil,
                              body: bodyData)
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(let serverResponse):
                guard let data = serverResponse.data else {
                    completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let user = try JSONDecoder().decode(UserDTO.self, from: data)
                    CoreDataManager.shared.updateOrCreateUserEntity(from: user)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Delete User
    
    /// Deletes a user by their ID (DELETE request).
    /// - Parameters:
    ///   - id: The ID of the user to delete.
    ///   - completion: Completion handler that returns success or failure.
    func deleteUser(with id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = Request(endpoint: UserEndpoint.deleteUser(id),
                              method: .delete,
                              paremetrs: nil,
                              body: nil)
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Upload Avatar
    
    /// Uploads a user's avatar (POST request with multipart form-data).
    /// - Parameters:
    ///   - userId: The ID of the user to upload the avatar for.
    ///   - image: The image to upload.
    ///   - fileName: The name of the file being uploaded.
    ///   - completion: Completion handler that returns the updated user data or an error.
    func uploadAvatar(for userId: String, image: UIImage, fileName: String, completion: @escaping (Result<UserDTO, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        let boundary = UUID().uuidString
        let endpoint = UploadAvatarEndpoint(userId: userId, boundary: boundary)
        
        var body = Data()
        let disposition = "form-data; name=\"file\"; filename=\"\(fileName)\""
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: \(disposition)\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let request = Request(endpoint: endpoint,
                              method: .post,
                              paremetrs: nil,
                              body: body)
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(let serverResponse):
                guard let data = serverResponse.data else {
                    completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let user = try JSONDecoder().decode(UserDTO.self, from: data)
                    CoreDataManager.shared.updateUserAvatar(image)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Download Avatar
    
    /// Downloads a user's avatar (GET request).
    /// - Parameters:
    ///   - user: The user whose avatar is being downloaded.
    ///   - completion: Completion handler that returns avatar data or an error.
    func downloadAvatar(for user: UserDTO, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let avatarUrl = user.avatarUrl, !avatarUrl.isEmpty else {
            completion(.failure(NSError(domain: "AvatarError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Avatar URL отсутствует"])))
            return
        }
        let endpoint = FileDownloadEndpoint(path: avatarUrl)
        let request = Request(endpoint: endpoint, method: .get, paremetrs: nil, body: nil)
        networkWorker.execute(with: request) { result in
            switch result {
            case .success(let serverResponse):
                if let data = serverResponse.data {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "AvatarError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не получены данные аватара"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
