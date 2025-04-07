import UIKit

/// Presenter responsible for managing the achievements and passing data to the view.
class AchievementsPresenter: AchievementsPresenterProtocol {
    
    // MARK: - VIPER References
    
    weak var view: AchievementsViewProtocol?
    var interactor: AchievementsInteractorProtocol?
    var router: AchievementsRouterProtocol?
    
    // MARK: - AchievementsPresenterProtocol Methods
    
    /// Called when the view is loaded to fetch achievements.
    func viewDidLoad() {
        interactor?.fetchAchievements()
    }
}

extension AchievementsPresenter: AchievementsInteractorOutputProtocol {
    
    /// Called when achievements are successfully fetched.
    /// - Parameter items: The list of achievement items.
    func didFetchAchievements(_ items: [AchievementItem]) {
        let displayItems = items.map { item -> AchievementDisplayItem in
            let progressValue: String
            if let userAchievement = item.userAchievement {
                progressValue = "\(userAchievement.progress)/\(item.achievement.max_progress)"
            } else {
                progressValue = "0/\(item.achievement.max_progress)"
            }
            let color: UIColor = (item.userAchievement?.achieved == true) ? .systemGreen : .systemBlue
            return AchievementDisplayItem(
                id: item.achievement.id,
                name: item.achievement.name,
                description: item.achievement.description,
                progress: progressValue,
                color: color
            )
        }
        view?.displayAchievements(displayItems)
    }
    
    /// Called when there is a failure to fetch achievements.
    /// - Parameter error: The error that occurred during fetching.
    func didFailToFetchAchievements(with error: Error) {
        view?.displayError(error)
    }
}
