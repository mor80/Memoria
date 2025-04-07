import Foundation

// MARK: - UserEndpoint

/// Enum representing the endpoints for user-related operations.
enum UserEndpoint: Endpoint {
    
    /// Endpoint for user login.
    case login
    
    /// Endpoint for user registration.
    case register
    
    /// Endpoint to get all users.
    case getAllUsers
    
    /// Endpoint to get a user by their ID.
    case getUserById(String)
    
    /// Endpoint to update a user by their ID.
    case updateUser(String)
    
    /// Endpoint to delete a user by their ID.
    case deleteUser(String)
    
    // MARK: - Endpoint Implementation
    
    /// The composite path for the user-related endpoints.
    var compositePath: String {
        switch self {
        case .login:
            return "/api/user/login"
        case .register:
            return "/api/user/add"
        case .getAllUsers:
            return "/api/user/get"
        case .getUserById(let userID):
            return "/api/user/get/\(userID)"
        case .updateUser(let userID):
            return "/api/user/update/\(userID)"
        case .deleteUser(let userID):
            return "/api/user/delete/\(userID)"
        }
    }
    
    /// The headers required for the request. The headers vary depending on the type of request.
    var headers: [String: String] {
        switch self {
        case .login:
            return ["Accept": "application/json",
                    "Content-Type": "application/x-www-form-urlencoded"]
        case .register:
            return ["Accept": "application/json",
                    "Content-Type": "application/json"]
        default:
            // Default headers for JSON requests with Authorization if available
            return ["Content-Type": "application/json",
                    "Authorization": CoreDataManager.shared.getToken()?.isEmpty == false ? "Bearer \(CoreDataManager.shared.getToken()!)" : ""]
        }
    }
    
    /// The parameters for the request (nil for this case).
    var paremetrs: [String: String]? { nil }
}
