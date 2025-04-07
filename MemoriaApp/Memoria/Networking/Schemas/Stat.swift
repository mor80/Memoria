import Foundation

struct UserGameStatDTO: Codable {
    let user_id: String
    let game_id: Int
    let high_score: Int
    let games_played: Int
}

struct UpdateUserGameStatDTO: Codable {
    let high_score: Int?
    let games_played: Int?
}
