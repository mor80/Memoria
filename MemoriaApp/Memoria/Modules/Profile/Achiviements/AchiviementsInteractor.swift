import UIKit

/// Interactor responsible for fetching achievements data and handling user progress.
class AchievementsInteractor: AchievementsInteractorProtocol {
    
    // MARK: - VIPER Reference
    
    weak var presenter: AchievementsInteractorOutputProtocol?
    
    // MARK: - Services
    
    private let achievementService: AchievementService
    private let userAchievementService: UserAchievementService
    
    // MARK: - Initialization
    
    init(achievementService: AchievementService = AchievementService(),
         userAchievementService: UserAchievementService = UserAchievementService()) {
        self.achievementService = achievementService
        self.userAchievementService = userAchievementService
    }
    
    // MARK: - Achievements Fetching
    
    func fetchAchievements() {
        // Fetch the current user from CoreDataManager
        let fetchedUser = CoreDataManager.shared.fetchUser()
        let userId = fetchedUser.dto.id
        
        achievementService.listAchievements { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let achievements):
                var achievementItems: [AchievementItem] = []
                let group = DispatchGroup()
                
                // If the user is not registered, set the progress to nil by default
                if userId.isEmpty {
                    achievementItems = achievements.map { achievement in
                        AchievementItem(achievement: achievement, userAchievement: nil)
                    }
                    DispatchQueue.main.async {
                        self.presenter?.didFetchAchievements(achievementItems)
                    }
                } else {
                    var achievementItemsTemp: [AchievementItem] = []
                    for achievement in achievements {
                        group.enter()
                        self.userAchievementService.getUserAchievement(for: userId, achievementId: achievement.id) { result in
                            switch result {
                            case .success(let userAchievement):
                                achievementItemsTemp.append(AchievementItem(achievement: achievement, userAchievement: userAchievement))
                            case .failure(_):
                                // If user progress data is not retrieved, consider progress as 0
                                achievementItemsTemp.append(AchievementItem(achievement: achievement, userAchievement: nil))
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        // Optionally sort by achievement id
                        achievementItems = achievementItemsTemp.sorted(by: { $0.achievement.id < $1.achievement.id })
                        self.presenter?.didFetchAchievements(achievementItems)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchAchievements(with: error)
                }
            }
        }
    }
}
