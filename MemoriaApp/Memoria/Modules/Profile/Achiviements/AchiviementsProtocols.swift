import UIKit

/// Protocol defining the responsibilities of the view in the Achievements module.
protocol AchievementsViewProtocol: AnyObject {
    /// Displays the list of achievements on the view.
    /// - Parameter achievements: The list of achievement display items.
    func displayAchievements(_ achievements: [AchievementDisplayItem])
    
    /// Displays an error message if fetching achievements fails.
    /// - Parameter error: The error that occurred.
    func displayError(_ error: Error)
}

/// Protocol defining the responsibilities of the presenter in the Achievements module.
protocol AchievementsPresenterProtocol: AnyObject {
    /// Called when the view is loaded to start fetching achievements.
    func viewDidLoad()
}

/// Protocol defining the responsibilities of the interactor in the Achievements module.
protocol AchievementsInteractorProtocol: AnyObject {
    /// Fetches the list of achievements from the service or database.
    func fetchAchievements()
}

/// Protocol defining the responsibilities of the interactor's output in the Achievements module.
protocol AchievementsInteractorOutputProtocol: AnyObject {
    /// Called when achievements are successfully fetched.
    /// - Parameter items: The list of achievement items.
    func didFetchAchievements(_ items: [AchievementItem])
    
    /// Called when there is a failure to fetch achievements.
    /// - Parameter error: The error that occurred.
    func didFailToFetchAchievements(with error: Error)
}

/// Protocol defining the responsibilities of the router in the Achievements module.
protocol AchievementsRouterProtocol: AnyObject {
    /// Navigates back to the previous screen.
    func navigateBack()
    
    /// Creates and returns the view controller for the Achievements module.
    /// - Returns: The `UIViewController` for the Achievements module.
    static func createModule() -> UIViewController
}
