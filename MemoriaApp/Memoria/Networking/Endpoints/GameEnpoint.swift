import Foundation

// MARK: - GameEndpoint

/// Enum representing the endpoints for game-related operations.
enum GameEndpoint: Endpoint {
    
    /// Endpoint to list all games.
    case listGames
    
    // MARK: - Endpoint Implementation
    
    /// The composite path for the game-related endpoints.
    var compositePath: String {
        switch self {
        case .listGames:
            return "/api/game"
        }
    }
    
    /// The headers required for the request, including Authorization if a token is available.
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "Authorization": CoreDataManager.shared.getToken()?.isEmpty == false ? "Bearer \(CoreDataManager.shared.getToken()!)" : ""
        ]
    }
    
    /// The parameters for the request (nil for this case).
    var paremetrs: [String : String]? { nil }
}
