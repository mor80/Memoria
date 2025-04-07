import UIKit

struct AchievementDisplayItem {
    let id: Int
    let name: String
    let description: String
    let progress: String
    let color: UIColor
}

struct AchievementItem {
    let achievement: AchievementDTO
    let userAchievement: UserAchievementDTO?
}
