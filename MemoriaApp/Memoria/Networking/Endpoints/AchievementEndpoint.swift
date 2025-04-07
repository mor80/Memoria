import Foundation

// MARK: - AchievementEndpoint

/// Enum representing the endpoints for user achievements.
enum AchievementEndpoint: Endpoint {
    
    /// Get a user's achievement by user ID and achievement ID.
    case getUserAchievement(userId: String, achievementId: Int)
    
    /// Update a user's achievement by user ID and achievement ID.
    case updateUserAchievement(userId: String, achievementId: Int)
    
    // MARK: - Endpoint Implementation
    
    /// The composite path for the endpoint, including the user ID and achievement ID.
    var compositePath: String {
        switch self {
        case .getUserAchievement(let userId, let achievementId),
             .updateUserAchievement(let userId, let achievementId):
            return "/api/user/\(userId)/achievements/\(achievementId)"
        }
    }
    
    /// The headers required for the request, including Authorization if a token is available.
    var headers: [String: String] {
        return ["Content-Type": "application/json",
                "Authorization": CoreDataManager.shared.getToken()?.isEmpty == false ? "Bearer \(CoreDataManager.shared.getToken()!)" : ""]
    }
    
    /// The parameters for the request (nil for this case).
    var paremetrs: [String : String]? { nil }
}

// MARK: - AchievementsEndpoint

/// Enum representing the endpoints for achievements.
enum AchievementsEndpoint: Endpoint {
    
    /// List all achievements.
    case listAchievements
    
    /// Get a specific achievement by its ID.
    case getAchievement(achievementId: Int)
    
    // MARK: - Endpoint Implementation
    
    /// The composite path for the endpoint, depending on the action (listing or getting an achievement).
    var compositePath: String {
        switch self {
        case .listAchievements:
            return "/api/achievement"
        case .getAchievement(let achievementId):
            return "/api/achievement/\(achievementId)"
        }
    }
    
    /// The headers required for the request, including Authorization if a token is available.
    var headers: [String: String] {
        return ["Content-Type": "application/json",
                "Authorization": CoreDataManager.shared.getToken()?.isEmpty == false ? "Bearer \(CoreDataManager.shared.getToken()!)" : ""]
    }
    
    /// The parameters for the request (nil for this case).
    var paremetrs: [String: String]? { nil }
}
