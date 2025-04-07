import Foundation

// MARK: - AchievementManager

/// Singleton class responsible for managing and updating user achievements.
final class AchievementManager {
    
    /// Shared instance of AchievementManager.
    static let shared = AchievementManager()
    
    private let userAchievementService = UserAchievementService()
    
    private init() {}
    
    // MARK: - Private Methods
    
    /// Fetches the user ID from the local storage. If the ID is empty, it returns `nil`.
    private func fetchUserId() -> String? {
        let fetchedUser = CoreDataManager.shared.fetchUser()
        let userId = fetchedUser.dto.id
        return userId.isEmpty ? nil : userId
    }
    
    // MARK: - Achievement Notifications
    
    /// Achievement "Beginning": Play your first game (max progress = 1)
    func notifyBeginning() {
        guard let userId = fetchUserId() else {
            print("User not authorized")
            return
        }
        
        let achievementId = 1
        let maxProgress = 1
        
        userAchievementService.getUserAchievement(for: userId, achievementId: achievementId) { result in
            switch result {
            case .success(let achievement):
                // If the achievement is already achieved, do nothing
                if achievement.achieved {
                    return
                }
                // If the progress is less than max progress, update the achievement
                if achievement.progress < maxProgress {
                    self.userAchievementService.updateUserAchievement(for: userId,
                                                                       achievementId: achievementId,
                                                                       achieved: true,
                                                                       progress: maxProgress) { updateResult in
                        switch updateResult {
                        case .success(let updatedAchievement):
                            print("Achievement 'Beginning' updated: \(updatedAchievement)")
                        case .failure(let error):
                            print("Failed to update 'Beginning': \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching 'Beginning' achievement: \(error.localizedDescription)")
            }
        }
    }
    
    /// Achievement "Memory Master": Win 10 Memory games (max progress = 10)
    func notifyMemoryMaster() {
        guard let userId = fetchUserId() else {
            print("User not authorized")
            return
        }
        
        let achievementId = 2
        let maxProgress = 10
        
        userAchievementService.getUserAchievement(for: userId, achievementId: achievementId) { result in
            switch result {
            case .success(let achievement):
                if achievement.achieved {
                    return
                }
                let newProgress = min(achievement.progress + 1, maxProgress)
                let achievedFlag = newProgress >= maxProgress
                self.userAchievementService.updateUserAchievement(for: userId,
                                                                    achievementId: achievementId,
                                                                    achieved: achievedFlag,
                                                                    progress: newProgress) { updateResult in
                    switch updateResult {
                    case .success(let updatedAchievement):
                        print("Achievement 'Memory Master' updated: \(updatedAchievement)")
                    case .failure(let error):
                        print("Failed to update 'Memory Master': \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error fetching 'Memory Master' achievement: \(error.localizedDescription)")
            }
        }
    }
    
    /// Achievement "Focus Champion": Win 15 Focus games (max progress = 15)
    func notifyFocusChampion() {
        guard let userId = fetchUserId() else {
            print("User not authorized")
            return
        }
        
        let achievementId = 3
        let maxProgress = 15
        
        userAchievementService.getUserAchievement(for: userId, achievementId: achievementId) { result in
            switch result {
            case .success(let achievement):
                if achievement.achieved {
                    return
                }
                let newProgress = min(achievement.progress + 1, maxProgress)
                let achievedFlag = newProgress >= maxProgress
                self.userAchievementService.updateUserAchievement(for: userId,
                                                                    achievementId: achievementId,
                                                                    achieved: achievedFlag,
                                                                    progress: newProgress) { updateResult in
                    switch updateResult {
                    case .success(let updatedAchievement):
                        print("Achievement 'Focus Champion' updated: \(updatedAchievement)")
                    case .failure(let error):
                        print("Failed to update 'Focus Champion': \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error fetching 'Focus Champion' achievement: \(error.localizedDescription)")
            }
        }
    }
    
    /// Achievement "Lightning Reflex": Win 20 Reaction games (max progress = 20)
    func notifyLightningReflex() {
        guard let userId = fetchUserId() else {
            print("User not authorized")
            return
        }
        
        let achievementId = 4
        let maxProgress = 20
        
        userAchievementService.getUserAchievement(for: userId, achievementId: achievementId) { result in
            switch result {
            case .success(let achievement):
                if achievement.achieved {
                    return
                }
                let newProgress = min(achievement.progress + 1, maxProgress)
                let achievedFlag = newProgress >= maxProgress
                self.userAchievementService.updateUserAchievement(for: userId,
                                                                    achievementId: achievementId,
                                                                    achieved: achievedFlag,
                                                                    progress: newProgress) { updateResult in
                    switch updateResult {
                    case .success(let updatedAchievement):
                        print("Achievement 'Lightning Reflex' updated: \(updatedAchievement)")
                    case .failure(let error):
                        print("Failed to update 'Lightning Reflex': \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error fetching 'Lightning Reflex' achievement: \(error.localizedDescription)")
            }
        }
    }
}
