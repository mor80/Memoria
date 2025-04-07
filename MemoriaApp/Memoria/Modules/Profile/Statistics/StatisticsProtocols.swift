import UIKit

// MARK: - View
/// Protocol defining the view's responsibilities in the Statistics module.
protocol StatisticsViewProtocol: AnyObject {
    /// Displays a list of statistics items on the view.
    /// - Parameter stats: A list of `StatDisplayItem` to display.
    func displayStatistics(_ stats: [StatDisplayItem])
    
    /// Displays an error message on the view.
    /// - Parameter error: The error to display.
    func displayError(_ error: Error)
}

// MARK: - Presenter
/// Protocol defining the presenter's responsibilities in the Statistics module.
protocol StatisticsPresenterProtocol: AnyObject {
    /// Called when the view is loaded to initiate the process of fetching statistics.
    func viewDidLoad()
}

// MARK: - Interactor
/// Protocol defining the interactor's responsibilities in the Statistics module.
protocol StatisticsInteractorProtocol: AnyObject {
    /// Fetches the statistics from the data source.
    func fetchStatistics()
}

// MARK: - Interactor Output
/// Protocol defining the interactor's output responsibilities.
protocol StatisticsInteractorOutputProtocol: AnyObject {
    /// Called when the statistics are successfully fetched.
    /// - Parameter statItems: A list of `StatItem` representing the statistics.
    func didFetchStatistics(_ statItems: [StatItem])
    
    /// Called when there is an error while fetching statistics.
    /// - Parameter error: The error that occurred.
    func didFailToFetchStatistics(with error: Error)
}

// MARK: - Router
/// Protocol defining the router's responsibilities in the Statistics module.
protocol StatisticsRouterProtocol: AnyObject {
    /// Navigates back to the previous screen.
    func navigateBack()
    
    /// Creates and returns the complete statistics module (view + VIPER stack).
    /// - Returns: A `UIViewController` instance representing the statistics module.
    static func createModule() -> UIViewController
}
