struct UserAchievementDTO: Codable {
    let user_id: String
    let achievement_id: Int
    let achieved: Bool
    let progress: Int
}

struct UpdateUserAchievementDTO: Codable {
    let achieved: Bool?
    let progress: Int?
}

struct AchievementDTO: Codable {
    let id: Int
    let name: String
    let description: String
    let max_progress: Int
}
